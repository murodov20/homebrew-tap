class Lat2cyr < Formula
  desc "O'zbek lotin→kirill real vaqtda transliteratsiya (macOS tray app)"
  homepage "https://github.com/murodov20/latin-cyrillic-converter-live"
  url "https://github.com/murodov20/latin-cyrillic-converter-live.git",
      tag: "v0.0.3"
  license "MIT"

  depends_on "python@3.12"
  depends_on :macos

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"

    # Virtual environment yaratish
    venv = libexec
    system python, "-m", "venv", venv
    pip = venv/"bin/pip"

    # Kutubxonalarni wheel sifatida o'rnatish
    system pip, "install", "--prefer-binary", "pynput>=1.7.6", "pystray>=0.19.5", "Pillow>=10.0.0"

    # Dastur fayllarini ko'chirish
    site_packages = Dir[venv/"lib/python*/site-packages"].first
    %w[main.py backend_macos.py backend_pynput.py transliterator.py
       config_loader.py settings_window.py config.json VERSION].each do |f|
      cp f, site_packages if File.exist?(f)
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
      exec "#{venv}/bin/python" "#{site_packages}/main.py" "$@"
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
