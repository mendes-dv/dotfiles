-- Roslyn LSP supplies on-type formatting (enabled in lspconfig LspAttach
-- autocmd). cindent acts as the fallback before the LSP attaches.
vim.bo.indentexpr = ""
vim.bo.cindent = true
-- :0  case labels
-- l1  align case body with case
-- g0  C++ scope decls at col 0
-- N-s nested namespaces don't add a level (file-scoped friendly)
-- t0  return type at col 0
-- (0  align inside open paren
-- Ws  continuation after ( gets one shiftwidth
-- m1  closing paren aligns with first non-blank of opening line
-- j1  Java-style anonymous class braces (helps lambdas)
-- )50 search 50 lines for matching paren
vim.bo.cinoptions = ":0,l1,g0,N-s,t0,(0,Ws,m1,j1,)50"
vim.bo.cinkeys = "0{,0},0),0],:,!^F,o,O,e"
vim.bo.cinwords = "if,else,while,do,for,switch,case,try,catch,finally,using,foreach,lock"
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
-- smartindent fights cindent — disable per-buffer
vim.bo.smartindent = false
