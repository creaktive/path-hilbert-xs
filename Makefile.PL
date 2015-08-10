use 5.008005;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME           => 'Path::Hilbert::XS',
    VERSION_FROM   => 'lib/Path/Hilbert/XS.pm',
    PREREQ_PM      => { 'Test::More' => 0 },
    ABSTRACT_FROM  => 'lib/Path/Hilbert/XS.pm',
    AUTHOR         => 'Sawyer X <xsawyerx@cpan.org>, Gonzalo Diethelm',
    #LIBS           => [''],
    DEFINE         => '',
    INC            => '-I.',
    OBJECT         => '$(O_FILES)',
);

