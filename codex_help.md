$ codex --help
Codex CLI

If no subcommand is specified, options will be forwarded to the interactive CLI.

Usage: codex-x86_64-pc-windows-msvc.exe [OPTIONS] [PROMPT]
       codex-x86_64-pc-windows-msvc.exe [OPTIONS] [PROMPT] <COMMAND>

Commands:
  exec        Run Codex non-interactively [aliases: e]
  login       Manage login
  logout      Remove stored authentication credentials
  mcp         Experimental: run Codex as an MCP server
  proto       Run the Protocol stream via stdin/stdout [aliases: p]
  completion  Generate shell completion scripts
  debug       Internal debugging commands
  apply       Apply the latest diff produced by Codex agent as a `git apply` to your local working tree [aliases: a]
  help        Print this message or the help of the given subcommand(s)

Arguments:
  [PROMPT]
          Optional user prompt to start the session

Options:
  -c, --config <key=value>
          Override a configuration value that would otherwise be loaded from `~/.codex/config.toml`. Use a dotted path
          (`foo.bar.baz`) to override nested values. The `value` portion is parsed as JSON. If it fails to parse as
          JSON, the raw string is used as a literal.

          Examples: - `-c model="o3"` - `-c 'sandbox_permissions=["disk-full-read-access"]'` - `-c
          shell_environment_policy.inherit=all`

  -i, --image <FILE>...
          Optional image(s) to attach to the initial prompt

  -m, --model <MODEL>
          Model the agent should use

      --oss
          Convenience flag to select the local open source model provider. Equivalent to -c model_provider=oss; verifies
          a local Ollama server is running

  -p, --profile <CONFIG_PROFILE>
          Configuration profile from config.toml to specify default options

  -s, --sandbox <SANDBOX_MODE>
          Select the sandbox policy to use when executing model-generated shell commands

          [possible values: read-only, workspace-write, danger-full-access]

  -a, --ask-for-approval <APPROVAL_POLICY>
          Configure when the model requires human approval before executing a command

          Possible values:
          - untrusted:  Only run "trusted" commands (e.g. ls, cat, sed) without asking for user approval. Will escalate
            to the user if the model proposes a command that is not in the "trusted" set
          - on-failure: Run all commands without asking for user approval. Only asks for approval if a command fails to
            execute, in which case it will escalate to the user to ask for un-sandboxed execution
          - on-request: The model decides when to ask the user for approval
          - never:      Never ask for user approval Execution failures are immediately returned to the model

      --full-auto
          Convenience alias for low-friction sandboxed automatic execution (-a on-failure, --sandbox workspace-write)

      --dangerously-bypass-approvals-and-sandbox
          Skip all confirmation prompts and execute commands without sandboxing. EXTREMELY DANGEROUS. Intended solely
          for running in environments that are externally sandboxed

  -C, --cd <DIR>
          Tell the agent to use the specified directory as its working root

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version