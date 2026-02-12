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
  })
end
