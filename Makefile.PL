use 5.008005;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME           => 'Path::Hilbert::XS',
    VERSION_FROM   => 'lib/Path/Hilbert/XS.pm',
    PREREQ_PM      => { 'Test::More' => 0 },
    ABSTRACT_FROM  => 'lib/Path/Hilbert/XS.pm',
    AUTHOR         => [
        'Sawyer X <xsawyerx@cpan.org>',
        'Gonzalo Diethelm <gonzus@cpan.org>',
    ],
    LICENSE        => 'mit',
    DEFINE         => '',
    INC            => '-I.',
    OBJECT         => '$(O_FILES)',
    META_MERGE     => {
        'meta-spec' => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'git://github.com/p5pclub/path-hilbert-xs.git',
                web  => 'https://github.com/p5pclub/path-hilbert-xs',
            },
        },
    },
);

