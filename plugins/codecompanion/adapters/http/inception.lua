---@diagnostic disable-next-line: miss-name
function()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "InceptionLabs",
    formatted_name = "InceptionLabs",
    url = "https://api.inceptionlabs.ai/v1/chat/completions",
    env = { api_key = "cmd:cat $HOME/.config/sops-nix/secrets/api-keys/INCEPTION" },
    schema = {
      -- see https://docs.inceptionlabs.ai/get-started/api-parameters#mercury-2

      -- Model selection
      model = {
        default = "mercury-2",  -- default: mercury-2   mercury-2|mercury-small
        choices = {
          ["mercury-2"] = { opts = { can_reason = true } },
          "mercury-small",
          -- only available to accounts created before February 24, 2026
          -- "mercury",
          -- "mercury-coder",
          -- "mercury-coder-small",
        },
      },
      -- Control the amount of reasoning
      reasoning_effort       = { default = "medium" },     -- default: medium      instant|low|medium|high

      -- Whether to return a best-effort summary of the model's reasoning
      reasoning_summary      = { default = true },         -- default: true        true|false

      -- Whether to delay the final response until the reasoning summary is ready
      reasoning_summary_wait = { default = false },        -- default: false       true|false

      -- Maximum number of tokens to generate
      max_tokens             = { default = 8192 },         -- default: 8192        1-50000

      -- Controls randomness
      temperature            = { default = 0.75 },         -- default: 0.75        0.5-1.0

      -- Stop sequences (up to 4)
      stop                   = { default = { } },          -- default: null        string[]|null

      -- Whether to stream the response
      stream                 = { default = false },        -- default: false       true|false

      stream_options         = { default = {
        -- get usage information
        -- include_usage = true
      } },

      -- Visualizes the diffusion process (requires stream=true)
      diffusing              = { default = false },        -- default: false       true|false

      -- A list of tools the model may call
      tools                  = { default = { } },          -- default: null        object[]|null
    },
  })
end
