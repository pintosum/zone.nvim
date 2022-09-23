-- TODO: add character mode instead of line mode
-- NOTE: opts: stage: ['aura', 'ictal']
local epilepsy = {}
local ns = vim.api.nvim_create_namespace('epilepsy')
local mod = require("zone.helper")
local fake_buf

-- local map = { 'orange', 'red', 'cyan', 'brown', 'magenta', 'gray', 'white' } --black
-- The palette
-- TODO: avoid this and take colors directly from current colorscheme
local map = {
    "#11121D", "#a0A8CD", "#32344a", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#ad8ee6", "#449dab",
    "#787c99", "#444b6a", "#ff7a93", "#b9f27c", "#ff9e64", "#7da6ff", "#bb9af7", "#0db9d7", "#acb0d0"
}

epilepsy.start = function(opts)
    opts = opts or { stage="aura" }
    local before_buf = vim.api.nvim_get_current_buf()

    fake_buf = mod.create_and_initiate(nil)

    mod.set_buf_view(before_buf)


    mod.on_each_tick(function()
        if not vim.api.nvim_buf_is_valid(fake_buf) then return end
        for i=0, #map do
            local color = map[math.ceil(math.random() * #map)]
            -- TODO: change to new hl api's
            -- vim.api.nvim_set_hl(ns, 'Epilepsy'..i, {fg=color})
            vim.cmd("hi Epilepsy"..i.." guifg="..color.." guibg=none")
        end

        for row=0,vim.api.nvim_buf_line_count(fake_buf) do
            local line = vim.api.nvim_buf_get_lines(fake_buf, row, row+1, false)[1]
            if line ~= nil then
                if opts.stage == "aura" then
                    for col=0, #line do
                        local hl = "Epilepsy"..math.ceil(math.random() * #map)
                        vim.api.nvim_buf_add_highlight(fake_buf, ns, hl, row, col, col+1)
                    end
                elseif opts.stage == "ictal" then
                    local hl = "Epilepsy"..math.ceil(math.random() * #map)
                    vim.api.nvim_buf_add_highlight(fake_buf, ns, hl, row, 0, -1)
                else
                    vim.notify("Not a valid stage!")
                end
            end
        end
    end)
end

return epilepsy