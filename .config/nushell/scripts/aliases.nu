export def mt [pattern?: string] {
  if $pattern == null { 
    mix test
  } else {

    let test_files = ls lib/**/* test/**/* | where {|f| $f.name =~ $".*($pattern).*_test.exs" } | get name
    let test_lines = ls lib/**/*_test.exs | 
      where {|f| (open $f.name) =~ $pattern } |
      each { |f|
        open $f.name | lines | enumerate |
        where { $in.item =~ ('(test\s|describe\s).*' ++ $pattern) } |
        each  { $"($f.name):($in.index + 1)" }
      } | flatten

    $test_files ++ $test_lines | echo ...$in

  }
}

export def mtw [] {
  fswatch lib test | mix test --listen-on-stdin --stale
}

alias im = iex -S mix
alias imp = iex -S mix phx.server
alias yeehaw = rally.sh
