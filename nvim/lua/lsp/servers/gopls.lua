local M = {}

M.filetypes = {
  "go","gomod"
}
M.settings = {
  gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    }

return M
