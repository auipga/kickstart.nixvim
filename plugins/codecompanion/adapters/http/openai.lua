---@diagnostic disable-next-line: miss-name
function()
  return require("codecompanion.adapters").extend("openai", {
    env = { api_key = "cmd:cat $HOME/.config/sops-nix/secrets/api-keys/work/OPENAI" },
    schema = {
      -- model       = { default = "gpt-5" },
      -- max_tokens  = { default = 2048 },
      -- temperature = { default = 0.2 },
      -- top_p       = { default = 0.95 },
    },
  })
end
