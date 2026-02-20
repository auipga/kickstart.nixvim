---@diagnostic disable-next-line: miss-name
function()
  return require("codecompanion.adapters").extend("gemini", {
    env = { api_key = "cmd:cat $HOME/.config/sops-nix/secrets/api-keys/GEMINI" },
    schema = {
      model       = { default = "gemini-2.5-flash" },
      max_tokens  = { default = 2048 },
      temperature = { default = 0.2 },
      top_p       = { default = 0.95 },
      reasoning_effort = { default = "medium" }, -- high|medium*|low|none
    },
  })
end
