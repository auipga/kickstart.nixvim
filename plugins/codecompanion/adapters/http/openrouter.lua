---@diagnostic disable-next-line: miss-name
function()
  return require("codecompanion.adapters").extend("openrouter", {
    env = { api_key = "cmd:cat $HOME/.config/sops-nix/secrets/api-keys/OPENROUTER" },
  })
end
