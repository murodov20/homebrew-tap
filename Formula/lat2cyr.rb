class Lat2cyr < Formula
  include Language::Python::Virtualenv

  desc "O'zbek lotin→kirill real vaqtda transliteratsiya (macOS tray app)"
  homepage "https://github.com/murodov20/latin-cyrillic-converter-live"
  url "https://github.com/murodov20/latin-cyrillic-converter-live.git",
      tag: "v0.0.2"
  license "MIT"

  depends_on "python@3.12"
  depends_on :macos

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install "pynput>=1.7.6"
    venv.pip_install "pystray>=0.19.5"
    venv.pip_install "Pillow>=10.0.0"

    # Dastur fayllarini ko'chirish
    libexec_site = libexec/"lib/python3.12/site-packages"
    %w[main.py backend_macos.py backend_pynput.py transliterator.py
       config_loader.py settings_window.py config.json VERSION].each do |f|
      libexec_site.install f if File.exist?(f)
    end

    # Config faylni saqlash
    pkgshare.install "config.json"

    # Wrapper skript
    (bin/"lat2cyr").write <<~EOS
      #!/bin/bash
      CONFIG_DIR="$HOME/.config/lat2cyr"
      if [ ! -f "$CONFIG_DIR/config.json" ]; then
        mkdir -p "$CONFIG_DIR"
        cp "#{pkgshare}/config.json" "$CONFIG_DIR/config.json"
      fi
      export LAT2CYR_CONFIG="$CONFIG_DIR/config.json"
      exec "#{libexec}/bin/python" "#{libexec_site}/main.py" "$@"
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
    assert_predicate bin/"lat2cyr", :exist?
  end
end
