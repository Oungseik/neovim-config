return {
  "jellydn/hurl.nvim",
  lazy = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Optional, for markdown rendering with render-markdown.nvim
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  ft = "hurl",
  opts = {
    env_file = {
      ".env",
      "hurl.env",
    },
    -- Show debugging info
    debug = true,
    -- Show notification on run
    show_notification = false,
    -- Show response in popup or split
    mode = "split",
    -- Default formatter
    formatters = {
      json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
      html = {
        "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
        "--parser",
        "html",
      },
      xml = {
        "tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
        "-xml",
        "-i",
        "-q",
      },
    },
    -- Default mappings for the response popup or split views
    mappings = {
      close = "q",       -- Close the response popup or split view
      next_panel = "<C-n>", -- Move to the next response popup window
      prev_panel = "<C-p>", -- Move to the previous response popup window
    },
  },
  keys = {
    -- Run API request
    { "<leader>r",  "<Nop>",                      desc = "+Request" },
    { "<leader>rr", "<cmd>HurlRunnerAt<CR>",      desc = "Run a request" },
    { "<leader>ra", "<cmd>HurlRunner<CR>",        desc = "Run All requests" },
    { "<leader>rt", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
    { "<leader>re", "<cmd>HurlRunnerToEnd<CR>",   desc = "Run Api request from current entry to end" },
    -- Run Hurl request in visual mode
    { "<leader>h",  ":HurlRunner<CR>",            desc = "Run selected requests",                    mode = "v" },
  },
}
