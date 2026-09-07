class StrudelTerm < Formula
  desc "Strudel live coding in the terminal: editor, piano roll, scope and mixer"
  homepage "https://github.com/apolyaker92/strudel-term"
  url "https://github.com/apolyaker92/strudel-term/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "87361daa2460a52838a09eccc60c99230e023507cd035d39f1677bb6860e0e2a"
  license "AGPL-3.0-or-later"

  # node-web-audio-api sets the floor at 22; the strudel packages only ask for 18
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # std_npm_args passes --ignore-scripts, so the package's own postinstall
    # never runs. It repoints @kabelsalat/web at its ESM build; without it
    # @strudel/core fails to import and the command does not start at all.
    # Run that one script rather than re-enabling every dependency's scripts.
    system "node", libexec/"lib/node_modules/strudel-term/scripts/patch-deps.mjs"
  end

  test do
    assert_match "strudel-term", shell_output("#{bin}/strudel-term --help")
  end
end
