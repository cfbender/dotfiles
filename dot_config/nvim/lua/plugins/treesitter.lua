-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "css",
      "elixir",
      "fish",
      "go",
      "graphql",
      "haskell",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "nu",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    },
  },
}
