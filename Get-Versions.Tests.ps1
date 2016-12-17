Describe 'Get-Versions' {
	Context 'bash' {
		It 'bash version' {
			[version]((bash --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'3.2')
		}
		
		It '/bin/sh is bash' {
			(/bin/sh --version)[0] | Should -Match '^GNU bash,'
		}
		
		It '/bin/sh version' {
			[version]((/bin/sh --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'3.2')
		}
	}

	Context 'binutils' {
		It 'binutils version greater' {
			[version]((ld --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'2.25')
		}
		
		It 'binutils version lower' {
			[version]((ld --version)[0] -replace '[^0-9.]') | Should -BeLessOrEqual ([version]'2.31.1')
		}
	}
	
	Context 'bison' {
		It 'bison version' {
			[version]((bison --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'2.7')
		}
		
		It '/usr/bin/yacc is bison' {
			(/usr/bin/yacc --version)[0] | Should -Match '^bison \(GNU Bison\)'
		}
		
		It '/usr/bin/yacc version' {
			[version]((/usr/bin/yacc --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'2.7')
		}
	}
	
	It 'bzip2 version' {
		[version](((bzip2 --version 2>&1)[0] -split ' ')[7] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'1.0.4')
	}
	
	It 'coreutils version' {
		[version]((chown --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'6.9')
	}
	
	It 'diffutils version' {
		[version]((diff --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'2.8.1')
	}
	
	It 'findutils version' {
		[version]((find --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'4.2.31')
	}
	
	Context 'gawk' {
		It 'gawk version' {
			[version]((gawk --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'4.0.1')
		}
		
		It '/usr/bin/awk is gawk' {
			(/usr/bin/awk --version)[0] | Should -Match '^GNU Awk '
		}
		
		It '/usr/bin/awk version' {
			[version]((/usr/bin/awk --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'4.0.1')
		}
	}
	
	Context 'gcc' {
		It 'gcc version greater' {
			[version](((gcc --version)[0] -split ' ')[3]) | Should -BeGreaterOrEqual ([version]'4.9')
		}
		
		It 'gcc version lower' {
			[version](((gcc --version)[0] -split ' ')[3]) | Should -BeLessOrEqual ([version]'8.2.0')
		}

		It 'g++ version greater' {
			[version](((g++ --version)[0] -split ' ')[3]) | Should -BeGreaterOrEqual ([version]'4.9')
		}
		
		It 'g++ version lower' {
			[version](((g++ --version)[0] -split ' ')[3]) | Should -BeLessOrEqual ([version]'8.2.0')
		}
	}
	
	Context 'glibc' {
		It 'glibc version greater' {
			[version](((ldd --version)[0] -split ' ')[-1]) | Should -BeGreaterOrEqual ([version]'2.11')
		}
		
		It 'glibc version lower' {
			[version](((ldd --version)[0] -split ' ')[-1]) | Should -BeLessOrEqual ([version]'2.28')
		}
	}
	
	It 'grep version' {
		[version]((grep --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'2.5.1')
	}

	It 'gzip version' {
		[version]((gzip --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'1.3.12')
	}
	
	It 'linux kernel version' {
		[version]((((cat /proc/version) -replace '[^0-9. ]').trim() -split ' ')[0]) | Should -BeGreaterOrEqual ([version]'3.2')
	}
	
	It 'm4 version' {
		[version]((m4 --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'1.4.10')
	}
	
	It 'make version' {
		[version]((make --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'4.0')
	}
	
	It 'patch version' {
		[version]((patch --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'2.5.4')
	}
	
	It 'perl version' {
		[version](((perl -V:version) -split '=')[1] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'5.8.8')
	}
	
	It 'sed version' {
		[version]((sed --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'4.1.5')
	}
	
	It 'tar version' {
		[version]((tar --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'1.22')
	}
	
	It 'texinfo version' {
		[version]((makeinfo --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'4.7')
	}

	It 'xz version' {
		[version]((xz --version)[0] -replace '[^0-9.]') | Should -BeGreaterOrEqual ([version]'5.0.0')
	}
}
