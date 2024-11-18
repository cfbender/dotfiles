import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)

IEx.configure(
  colors: [
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :light_green,
      boolean: [:light_blue],
      nil: [:magenta, :bright]
    ],
    ls_directory: :cyan,
    ls_device: :yellow,
    doc_code: :green,
    doc_inline_code: :magenta,
    doc_headings: [:cyan, :underline],
    doc_title: [:cyan, :bright, :underline]
  ],
  default_prompt:
    [
      :light_magenta,
      # plain string
      " %prefix (%counter)",
      ">",
      :white,
      :reset
    ]
    |> IO.ANSI.format()
    |> IO.chardata_to_string(),

  continuation_prompt:
    [
      :light_magenta,
      # plain string
      " ...",
      ">",
      :white,
      :reset
    ]
    |> IO.ANSI.format()
    |> IO.chardata_to_string()
)
