require('oil').setup {
    default_file_explorer = true,
    delete_to_trash = false,
    view_options = {
        show_hidden = true,
        natural_order = false,
        sort = {
            { "type", "asc" },
            { "name", "asc" },
        },
    },
    experimental_wait_for_changes = false,
}
