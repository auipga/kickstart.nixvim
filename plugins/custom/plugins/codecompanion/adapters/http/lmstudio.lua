function()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "lmstudio",
    formatted_name = "LM Studio",
    env = { url = "http://localhost:1234", },
    schema = {
      model = {
        -- default = "phi-3-mini-128k-instruct-imatrix-smashed@q8_0",

        -- Devstral-Small-2-24B-Instruct-2512 : reasoning and tools
        -- default = "devstral-small-2-24b-instruct-2512@q3_k_m", -- bartowski 11.5 GBV (Imatrix ensures tool-calling syntax stays broken-free)
        -- default = "TODO: downloading @q3_k_s", -- bartowski 10.40 GB
        -- default = "devstral-small-2-24b-instruct-2512@iq2_m", -- unsloth 10.0 GB
        -- default = "devstral-small-2-24b-instruct-2512@q4_k_s", -- unsloth 15.3 GB
        -- default = "mistralai/devstral-small-2-2512", -- mistralai 15.21 GB

        -- unsloth/Magistral-Small-2506-GGUF-Q3_K_S -- 12.16 GB Dynamic 2.0 provides better reasoning traces for complex logic.
        -- default = "magistral-small-2506@q3_k_s", -- unsloth 12.2 GB
        -- default = "magistral-small-2506@iq2_m", -- unsloth 10.0 GB

        -- default = "mistralai/codestral-22b-v0.1"; -- 13.3 GB 4.7 tps

        -- Ministral-3-8B-Instruct-2512 :
        -- default = "mistralai_ministral-3-8b-instruct-2512@q8_0"; -- bartowski 9.89 GB, 8.5 GBV Top Choice
        -- default = "mistralai_ministral-3-8b-instruct-2512@q4_k_s"; -- bartowski 5.81 GB
        default = "ministral-3-8b-instruct-2512@q4_k_m"; -- unsloth 6.91 GB, 5.2 GBV Speed Choice (Optimized for lowest latency)
        -- default = "ministral-3-8b-instruct-2512@q4_k_s"; -- unsloth 6.67 GB
      },
    },
  })
end
