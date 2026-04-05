local org_path = function(path)
  local org_directory = '~/Notes'
  return ('%s/%s'):format(org_directory, path)
end

return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      require('orgmode').setup({
        org_startup_indented = true,
        org_todo_keywords = {
          'TODO(t)', 'WAITING(w)', 'PROGRESS(p)', '|', 'DONE(d)', 'REJECTED(r)'
        },
        org_capture_templates = {
          t = {
            description = 'Refile',
            template = '* TODO %?\nDEADLINE: %T',
          },
          n = {
            description = 'Quick Note (prompted project)',
            template = '* %^{Project} - %?\nCREATED: %U',
            target = org_path('notes.org'),
          },
          f = {
  description = 'Project Finding (detailed)',
  template = [[
* Finding: %^{Title}
:PROPERTIES:
:Project: %^{Project}
:Type: %^{Type|Bug|Observation|Decision|Improvement|Investigation}
:CREATED: %U
:END:

- **Description**:  
  %?

- **Linked Code / Logs**:  
  - 

]],
  target = org_path('refile.org'),
},
          T = {
            description = 'Todo',
            template = '* TODO %?\nDEADLINE: %T',
            target = org_path('todos.org'),
          },
          w = {
            description = 'Work todo',
            template = '* TODO %?\nDEADLINE: %T',
            target = org_path('work.org'),
          },
        },
        org_agenda_files = { '~/Notes/**/*' },
        org_default_notes_file = '~/Notes/refile.org',
        org_refile_targets = {
  { org_path('keycloak-adapter.org'), { max_level = 2 } },
  { org_path('koppetaal-adatper.org'), { max_level = 2 } },
},

      })
    end
  },
  {
    'akinsho/org-bullets.nvim',
    ft = 'org',
    config = function()
      require('org-bullets').setup()
    end
  }
}


