-- lua/my/dial_comment_enum.lua
local M = {}

local function find_comment(line)
    local s0, e0

    local function consider(pattern, len)
        local s = line:find(pattern)
        if s and (not s0 or s < s0) then
            s0, e0 = s, len
        end
    end

    -- Require at least one whitespace before marker to avoid "http://..." false positives.
    consider("%s%-%-", 2) -- " --"
    consider("%s#",    1) -- " #"
    consider("%s//",   2) -- " //"

    if not s0 then return nil end
    return s0 + 1, e0 -- position of marker itself, and marker length
end

local function find_options(comment)
    local m = vim.fn.matchstrpos(comment, [[\v\s*(\w+\|)+\w+]])
    local match, s0 = m[1], m[2]
    if not match or match == "" or s0 < 0 then
        return nil
    end
    match = match:gsub("^%s+", "")
    return match
end

local function find_target(line, cpos)
    local s0, e0
    local i = 1
    while true do
        local s, e = line:find("[%w_]+", i)
        if not s or s >= cpos then break end
        s0, e0 = s, e
        i = e + 1
    end
    return s0, e0
end

function M.new(opts)
    opts = opts or {}
    local cyclic = opts.cyclic or false

    -- State captured between find() and add() for a single operation.
    local state = { options = nil, index = nil }

    return require("dial.augend").user.new({
        find = function(line, _)
            local cpos, clen = find_comment(line)
            if not cpos then return nil end

            local comment = line:sub(cpos + clen)
            local options_str = find_options(comment)
            if not options_str then return nil end

            local options = vim.split(options_str, "|", { plain = true, trimempty = true })
            state.options = options
            state.index = vim.iter(options):enumerate():fold({}, function(t, i, v) t[v] = i; return t end)

            local from, to = find_target(line, cpos)
            if not from then return nil end

            return { from = from, to = to }
        end,

        add = function(text, addend, _)
            local options = state.options
            local index = state.index
            if not options or not index then return nil end

            local cur = index[text]
            if not cur then
                -- If current value isn't in the list, treat it as the first element.
                cur = 1
            end

            local nxt = cur + addend

            if cyclic == false and (nxt < 1 or nxt > #options) then
                return { text = text, cursor = #text }
            end

            nxt = ((nxt - 1) % #options) + 1
            return { text = options[nxt], cursor = #options[nxt] }
        end,
    })
end

return M
