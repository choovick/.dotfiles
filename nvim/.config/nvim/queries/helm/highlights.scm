; Helm-specific Treesitter highlights (see ftplugin/helm.lua for hl links).
; Inherits built-in gotmpl/helm queries; these captures use higher priority
; so define/keywords/delimiters/.Values stand out on gruvbox.

(define_action
  "define" @helm.define
  (#set! priority 120))

(if_action
  [
    "if"
    "else"
    "end"
  ] @helm.keyword
  (#set! priority 120))

(with_action
  [
    "with"
    "else"
    "end"
  ] @helm.keyword
  (#set! priority 120))

(range_action
  [
    "range"
    "else"
    "end"
  ] @helm.keyword
  (#set! priority 120))

([
  "{{"
  "}}"
  "{{-"
  "-}}"
] @helm.delimiter
  (#set! priority 120))

(selector_expression
  operand: (field
    name: (identifier) @helm.root
    (#any-of? @helm.root "Values" "Chart" "Release" "Capabilities" "Files" "Template"))
  (#set! priority 120))
