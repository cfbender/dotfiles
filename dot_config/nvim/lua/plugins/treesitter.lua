-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "typescript",
      "javascript",
      "jsdoc",
      "elixir",
      "graphql",
      "rust",
      "tsx",
      "toml",
      "fish",
      "json",
      "yaml",
      "css",
      "html",
      "lua",
      "vim",
      "regex",
      "haskell",
    })
  end,
}
