function toggleTree()
    function openTree()
        require'bufferline.state'.set_offset(30, 'FileTree')
        require'nvim-tree'.find_file(true)
    end

    function closeTree()
        require'bufferline.state'.set_offset(0)
        require'nvim-tree'.close()
    end

    local view = require 'nvim-tree.view'
    local lib = require 'nvim-tree.lib'
    if view.win_open() then
        closeTree()
    else
        openTree()
    end
end

vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>lua toggleTree()<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>q', ':BufferClose<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>qa', ':BufferCloseAllButCurrent<cr>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<c-l>', ':BufferNext<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-h>', ':BufferPrevious<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-s>', ':BufferPick<cr>',
                        {noremap = true, silent = true})
