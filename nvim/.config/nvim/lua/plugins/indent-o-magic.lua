return {
  "Darazaki/indent-o-matic",
  opts = {
    -- Global settings (optional, used as fallback)
    max_lines = 2048,
    standard_widths = { 2, 4, 8 },

    -- Disable indent-o-matic for LISP files
    filetype_lisp = {
      max_lines = 0,
    },

    -- Bitbucket markdown files should use 3 spaces
    filetype_markdown = {
      standard_widths = { 3 },
    },

    -- shell scipts should use 2 spaces
    filetype_sh = {
      standard_widths = { 2 },
    },

    -- Don't detect 8 spaces indentations inside files without a filetype
    filetype_ = {
      standard_widths = { 2, 4 },
    },
  },
}
