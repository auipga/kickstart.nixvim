-- TODO: https://codecompanion.olimorris.dev/extending/adapters#function-calling-tool-use
function()
  return require("codecompanion.adapters").extend("ollama", {
    name = "ollama",
    formatted_name = "ollama",
    schema = {
      model       = { default = "mistral:7b-instruct-v0.3-q4_K_M" },
      num_ctx     = { default = 16384 },
      think       = { default = false },
      keep_alive  = { default = "5m" },
      max_tokens  = { default = 2000 },
      temperature = { default = 0.2 },
      top_p       = { default = 0.95 },
    },
    tools = {
      enabled = true,
    },
  })
end
