export_locals_without_parens = [
  assert_flash: 3,
  field: 3
]

[
  export: [[locals_without_parens: export_locals_without_parens]],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: export_locals_without_parens,
  plugins: [Phoenix.LiveView.HTMLFormatter],
]
