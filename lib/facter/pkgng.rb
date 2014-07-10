
Facter.add("pkgng_supported") do
  confine :kernel => "FreeBSD"

  setcode do
    kernel = Facter.value('kernelversion')
    if kernel =~ /^(8|9|10|11)(\.[0-9])?/
      "true"
    end
  end

end

Facter.add("pkgng_enabled") do
  confine :kernel => "FreeBSD"

  setcode do
    if system("TMPDIR=/dev/null ASSUME_ALWAYS_YES=1 PACKAGESITE=file:///nonexistent pkg info pkg >/dev/null 2>&1")
      "true"
    else
      kernel = Facter.value('kernelversion')
      if kernel =~ /^(10|11)(\.[0-9])?/
        if system("pkg -N >/dev/null 2>&1")
          "true"
        end
      end
    end
  end

end

Facter.add("pkgng_version") do
  confine :kernel => "FreeBSD"

  setcode do
    if Facter.value('pkgng_enabled') == "true"
      Facter::Util::Resolution.exec("pkg -v 2>/dev/null")
    end
  end

end
