---@diagnostic disable-next-line: miss-name
function()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "llama.cpp",
    formatted_name = "llama.cpp",
    env = {
      url = "http://127.0.0.1:8012",
      api_key = "TERM",
      chat_url = "/v1/chat/completions",
    },

    -- llama.cpp with --reasoning-format deepseek
    -- https://codecompanion.olimorris.dev/configuration/adapters-http#llama-cpp-with-reasoning-format-deepseek
    -- handlers = {
    --   parse_message_meta = function(self, data)
    --     local extra = data.extra
    --     if extra and extra.reasoning_content then
    --       data.output.reasoning = { content = extra.reasoning_content }
    --       if data.output.content == "" then
    --         data.output.content = nil
    --       end
    --     end
    --     return data
    --   end,
    -- },
  })
end
