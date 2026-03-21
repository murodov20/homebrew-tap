class Lat2cyr < Formula
  include Language::Python::Virtualenv

  desc "O'zbek lotin→kirill real vaqtda transliteratsiya (macOS tray app)"
  homepage "https://github.com/murodov20/latin-cyrillic-converter-live"
  url "https://github.com/murodov20/latin-cyrillic-converter-live.git",
      tag: "v0.0.2"
  license "MIT"

  depends_on "python@3.12"
  depends_on :macos

  resource "pynput" do
    url "https://files.pythonhosted.org/packages/f0/c3/dccf44c68225046df5324db0cc7d563a560635355b3e5f1d249468268a6f/pynput-1.8.1.tar.gz"
    sha256 "70d7c8373ee98911004a7c938742242840a5628c004573d84ba849d4601df81e"
  end

  resource "pystray" do
    url "https://files.pythonhosted.org/packages/5c/64/927a4b9024196a4799eba0180e0ca31568426f258a4a5c90f87a97f51d28/pystray-0.19.5-py2.py3-none-any.whl"
    sha256 "a0c2229d02cf87207297c22d86ffc57c86c227517b038c0d3c59df79295ac617"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/1f/42/5c74462b4fd957fcd7b13b04fb3205ff8349236ea74c7c375766d6c82288/pillow-12.1.1.tar.gz"
    sha256 "9ad8fa5937ab05218e2b6a4cff30295ad35afd2f83ac592e68c0d871bb0fdbc4"
  end

  def install
    virtualenv_install_with_resources

    # Config faylni ko'chirish
    pkgshare.install "config.json"

    # Wrapper skript yaratish
    (bin/"lat2cyr").unlink if (bin/"lat2cyr").exist?
    (bin/"lat2cyr").write <<~EOS
      #!/bin/bash
      # Config faylni foydalanuvchi papkasiga ko'chirish (agar yo'q bo'lsa)
      CONFIG_DIR="$HOME/.config/lat2cyr"
      if [ ! -f "$CONFIG_DIR/config.json" ]; then
        mkdir -p "$CONFIG_DIR"
        cp "#{pkgshare}/config.json" "$CONFIG_DIR/config.json"
      fi
      export LAT2CYR_CONFIG="$CONFIG_DIR/config.json"
      exec "#{libexec}/bin/python" "#{libexec}/lib/python3.12/site-packages/main.py" "$@"
    EOS
    chmod 0755, bin/"lat2cyr"
  end

  def caveats
    <<~EOS
      Accessibility ruxsatnomasi kerak:
        System Settings → Privacy & Security → Accessibility
        ga Terminal ilovangizni qo'shing.

      Ishga tushirish:
        lat2cyr

      Transliteratsiyani yoqish/o'chirish:
        Cmd+F11

      Sozlamalar:
        ~/.config/lat2cyr/config.json
    EOS
  end

  test do
    assert_match "version", shell_output("#{bin}/lat2cyr --help 2>&1", 1)
  end
end
