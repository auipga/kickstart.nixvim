function()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "lmstudio",
    formatted_name = "LM Studio",
    env = { url = "http://localhost:1234", },
    schema = {
      model = {
        -- default = "",
      },
    },
  })
end
