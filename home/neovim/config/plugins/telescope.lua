local telescope = require('telescope')
telescope.setup {
    defaults = {
        file_ignore_patterns = {
            ".git/",
        },
        mappings = {
            n = {
                ["q"] = require("telescope.actions").close
            },
        },
        layout_config = {
            height = 0.6,
            preview_cutoff = 120,
        },
        preview = {
            filesize_limit = 1, -- MB
        }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            overrider_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
telescope.load_extension('fzf')
