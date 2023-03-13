return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-emoji",
  },
  opts = function(_, opts)
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    local function next_item()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
      else
        cmp.complete()
      end
    end

    return require("astronvim.utils").extend_tbl(opts, {
      window = {
        completion = {
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:Visual,Search:None",
          border = "none",
          col_offset = -1,
          side_padding = 0,
        },
      },
      -- CMP Source Priorities
      -- modify here the priorities of default cmp sources
      -- higher value == higher priority
      -- The value can also be set to a boolean for disabling default sources:
      -- false == disabled
      -- true == 1000
      sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "emoji", priority = 700 },
        { name = "calc", priority = 650 },
        { name = "path", priority = 500 },
        { name = "buffer", priority = 250 },
      },
      mapping = {
        ["<C-n>"] = next_item,
        ["<C-j>"] = next_item,
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
    })
  end,
}
