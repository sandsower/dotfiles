-- Telescope configuration
require('telescope').setup({
  defaults = {
    -- Ensure files are opened normally, not as new buffers
    mappings = {
      i = {
        -- Keep default mappings
      },
    },
  },
})

-- Ensure buffers opened by telescope are properly configured
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local bufname = vim.api.nvim_buf_get_name(buf)

    -- If it's a real file that exists
    if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
      -- Ensure it's marked as read (not a new file)
      vim.bo[buf].modified = false
    end
  end,
})
