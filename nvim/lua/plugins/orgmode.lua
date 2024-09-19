local org_path = function(path)
  local org_directory = '/Users/mendes/Library/CloudStorage/ProtonDrive-pirate.holi@proton.me-folder/notes'
  return ('%s/%s'):format(org_directory, path)
end
return{
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup({
			  org_startup_indented = true,

			  org_todo_keywords = { 'TODO(t)', 'WAITING(w)', 'PROGRESS(p)', '|', 'DONE(d)', 'REJECTED(r)' },

	 org_capture_templates = {
	    t = {
	      description = 'Refile',
	      template = '* TODO %?\nDEADLINE: %T',
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
      org_agenda_files = { '/Users/mendes/Library/CloudStorage/ProtonDrive-pirate.holi@proton.me-folder/notes/**/*' },
      org_default_notes_file = '/Users/mendes/Library/CloudStorage/ProtonDrive-pirate.holi@proton.me-folder/notes/refile.org',
    })

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}

