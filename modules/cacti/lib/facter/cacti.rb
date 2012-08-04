Facter.add("cacti_version") do
    setcode do
        %x{/bin/rpm -q cacti|/bin/cut -c 7-12}.chomp
    end
end

