---@diagnostic disable-next-line: miss-name
function()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "lmstudio",
    formatted_name = "LM Studio",
    env = { url = "http://localhost:1234", },
    schema = {
      model = {
        default = "ministral-3-8b-instruct-2512@q4_k_m",
      },
    },
  })
end
