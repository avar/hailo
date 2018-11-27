use v5.28.0;
use utf8;
use strict;
use warnings;
use Encode qw<encode_utf8>;
use Data::Section -setup;
use Test::More;
use Hailo::Tokenizer::Words;

binmode $_, ':encoding(utf8)' for (*STDOUT, *STDERR);

BEGIN {
    if ($] < 5.012000) {
        plan skip_all => "This test relies on Perl >=5.12's Unicode matching";
    }

    my $got_yaml;
    eval {
        require YAML::XS;
        YAML::XS->import('Dump', 'Load');
        $got_yaml = 1;
    };
    plan skip_all => "Haven't got YAML::XS" if !$got_yaml;
}

plan tests => '2501';

my $self = bless {} => __PACKAGE__;
my $text = ${ $self->section_data("UTF-8 encoded sample plain-text file") };
my $toke = Hailo::Tokenizer::Words->new();
my $parsed = $toke->make_tokens($text);

# This is how the YAML::XS output was produced:
#binmode *STDERR;
#print STDERR Dump($parsed);
#exit;

my $yaml = Load(encode_utf8(${ $self->section_data("YAML::XS result") }));
for (my $i = 0; $i < @$yaml; $i++) {
    is($parsed->[$i][0], $yaml->[$i][0], "Token #$i: type matches");
    is($parsed->[$i][1], $yaml->[$i][1], "Token #$i: content matches");
}

is(scalar(@$parsed), scalar(@$yaml), "Number of tokens matches");

__DATA__
__[ UTF-8 encoded sample plain-text file ]__
UTF-8 encoded sample plain-text file
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

Markus Kuhn [ˈmaʳkʊs kuːn] <http://www.cl.cam.ac.uk/~mgk25/> — 2002-07-25


The ASCII compatible UTF-8 encoding used in this plain-text file
is defined in Unicode, ISO 10646-1, and RFC 2279.


Using Unicode/UTF-8, you can write in emails and source code things such as

Mathematics and sciences:

  ∮ E⋅da = Q,  n → ∞, ∑ f(i) = ∏ g(i),      ⎧⎡⎛┌─────┐⎞⎤⎫
                                            ⎪⎢⎜│a²+b³ ⎟⎥⎪
  ∀x∈ℝ: ⌈x⌉ = −⌊−x⌋, α ∧ ¬β = ¬(¬α ∨ β),    ⎪⎢⎜│───── ⎟⎥⎪
                                            ⎪⎢⎜⎷ c₈   ⎟⎥⎪
  ℕ ⊆ ℕ₀ ⊂ ℤ ⊂ ℚ ⊂ ℝ ⊂ ℂ,                   ⎨⎢⎜       ⎟⎥⎬
                                            ⎪⎢⎜ ∞     ⎟⎥⎪
  ⊥ < a ≠ b ≡ c ≤ d ≪ ⊤ ⇒ (⟦A⟧ ⇔ ⟪B⟫),      ⎪⎢⎜ ⎲     ⎟⎥⎪
                                            ⎪⎢⎜ ⎳aⁱ-bⁱ⎟⎥⎪
  2H₂ + O₂ ⇌ 2H₂O, R = 4.7 kΩ, ⌀ 200 mm     ⎩⎣⎝i=1    ⎠⎦⎭

Linguistics and dictionaries:

  ði ıntəˈnæʃənəl fəˈnɛtık əsoʊsiˈeıʃn
  Y [ˈʏpsilɔn], Yen [jɛn], Yoga [ˈjoːgɑ]

APL:

  ((V⍳V)=⍳⍴V)/V←,V    ⌷←⍳→⍴∆∇⊃‾⍎⍕⌈

Nicer typography in plain text files:

  ╔══════════════════════════════════════════╗
  ║                                          ║
  ║   • ‘single’ and “double” quotes         ║
  ║                                          ║
  ║   • Curly apostrophes: “We’ve been here” ║
  ║                                          ║
  ║   • Latin-1 apostrophe and accents: '´`  ║
  ║                                          ║
  ║   • ‚deutsche‘ „Anführungszeichen“       ║
  ║                                          ║
  ║   • †, ‡, ‰, •, 3–4, —, −5/+5, ™, …      ║
  ║                                          ║
  ║   • ASCII safety test: 1lI|, 0OD, 8B     ║
  ║                      ╭─────────╮         ║
  ║   • the euro symbol: │ 14.95 € │         ║
  ║                      ╰─────────╯         ║
  ╚══════════════════════════════════════════╝

Combining characters:

  STARGΛ̊TE SG-1, a = v̇ = r̈, a⃑ ⊥ b⃑

Greek (in Polytonic):

  The Greek anthem:

  Σὲ γνωρίζω ἀπὸ τὴν κόψη
  τοῦ σπαθιοῦ τὴν τρομερή,
  σὲ γνωρίζω ἀπὸ τὴν ὄψη
  ποὺ μὲ βία μετράει τὴ γῆ.

  ᾿Απ᾿ τὰ κόκκαλα βγαλμένη
  τῶν ῾Ελλήνων τὰ ἱερά
  καὶ σὰν πρῶτα ἀνδρειωμένη
  χαῖρε, ὦ χαῖρε, ᾿Ελευθεριά!

  From a speech of Demosthenes in the 4th century BC:

  Οὐχὶ ταὐτὰ παρίσταταί μοι γιγνώσκειν, ὦ ἄνδρες ᾿Αθηναῖοι,
  ὅταν τ᾿ εἰς τὰ πράγματα ἀποβλέψω καὶ ὅταν πρὸς τοὺς
  λόγους οὓς ἀκούω· τοὺς μὲν γὰρ λόγους περὶ τοῦ
  τιμωρήσασθαι Φίλιππον ὁρῶ γιγνομένους, τὰ δὲ πράγματ᾿
  εἰς τοῦτο προήκοντα,  ὥσθ᾿ ὅπως μὴ πεισόμεθ᾿ αὐτοὶ
  πρότερον κακῶς σκέψασθαι δέον. οὐδέν οὖν ἄλλο μοι δοκοῦσιν
  οἱ τὰ τοιαῦτα λέγοντες ἢ τὴν ὑπόθεσιν, περὶ ἧς βουλεύεσθαι,
  οὐχὶ τὴν οὖσαν παριστάντες ὑμῖν ἁμαρτάνειν. ἐγὼ δέ, ὅτι μέν
  ποτ᾿ ἐξῆν τῇ πόλει καὶ τὰ αὑτῆς ἔχειν ἀσφαλῶς καὶ Φίλιππον
  τιμωρήσασθαι, καὶ μάλ᾿ ἀκριβῶς οἶδα· ἐπ᾿ ἐμοῦ γάρ, οὐ πάλαι
  γέγονεν ταῦτ᾿ ἀμφότερα· νῦν μέντοι πέπεισμαι τοῦθ᾿ ἱκανὸν
  προλαβεῖν ἡμῖν εἶναι τὴν πρώτην, ὅπως τοὺς συμμάχους
  σώσομεν. ἐὰν γὰρ τοῦτο βεβαίως ὑπάρξῃ, τότε καὶ περὶ τοῦ
  τίνα τιμωρήσεταί τις καὶ ὃν τρόπον ἐξέσται σκοπεῖν· πρὶν δὲ
  τὴν ἀρχὴν ὀρθῶς ὑποθέσθαι, μάταιον ἡγοῦμαι περὶ τῆς
  τελευτῆς ὁντινοῦν ποιεῖσθαι λόγον.

  Δημοσθένους, Γ´ ᾿Ολυνθιακὸς

Georgian:

  From a Unicode conference invitation:

  გთხოვთ ახლავე გაიაროთ რეგისტრაცია Unicode-ის მეათე საერთაშორისო
  კონფერენციაზე დასასწრებად, რომელიც გაიმართება 10-12 მარტს,
  ქ. მაინცში, გერმანიაში. კონფერენცია შეჰკრებს ერთად მსოფლიოს
  ექსპერტებს ისეთ დარგებში როგორიცაა ინტერნეტი და Unicode-ი,
  ინტერნაციონალიზაცია და ლოკალიზაცია, Unicode-ის გამოყენება
  ოპერაციულ სისტემებსა, და გამოყენებით პროგრამებში, შრიფტებში,
  ტექსტების დამუშავებასა და მრავალენოვან კომპიუტერულ სისტემებში.

Russian:

  From a Unicode conference invitation:

  Зарегистрируйтесь сейчас на Десятую Международную Конференцию по
  Unicode, которая состоится 10-12 марта 1997 года в Майнце в Германии.
  Конференция соберет широкий круг экспертов по  вопросам глобального
  Интернета и Unicode, локализации и интернационализации, воплощению и
  применению Unicode в различных операционных системах и программных
  приложениях, шрифтах, верстке и многоязычных компьютерных системах.

Thai (UCS Level 2):

  Excerpt from a poetry on The Romance of The Three Kingdoms (a Chinese
  classic 'San Gua'):

  [----------------------------|------------------------]
    ๏ แผ่นดินฮั่นเสื่อมโทรมแสนสังเวช  พระปกเกศกองบู๊กู้ขึ้นใหม่
  สิบสองกษัตริย์ก่อนหน้าแลถัดไป       สององค์ไซร้โง่เขลาเบาปัญญา
    ทรงนับถือขันทีเป็นที่พึ่ง           บ้านเมืองจึงวิปริตเป็นนักหนา
  โฮจิ๋นเรียกทัพทั่วหัวเมืองมา         หมายจะฆ่ามดชั่วตัวสำคัญ
    เหมือนขับไสไล่เสือจากเคหา      รับหมาป่าเข้ามาเลยอาสัญ
  ฝ่ายอ้องอุ้นยุแยกให้แตกกัน          ใช้สาวนั้นเป็นชนวนชื่นชวนใจ
    พลันลิฉุยกุยกีกลับก่อเหตุ          ช่างอาเพศจริงหนาฟ้าร้องไห้
  ต้องรบราฆ่าฟันจนบรรลัย           ฤๅหาใครค้ำชูกู้บรรลังก์ ฯ

  (The above is a two-column text. If combining characters are handled
  correctly, the lines of the second column should be aligned with the
  | character above.)

Ethiopian:

  Proverbs in the Amharic language:

  ሰማይ አይታረስ ንጉሥ አይከሰስ።
  ብላ ካለኝ እንደአባቴ በቆመጠኝ።
  ጌጥ ያለቤቱ ቁምጥና ነው።
  ደሀ በሕልሙ ቅቤ ባይጠጣ ንጣት በገደለው።
  የአፍ ወለምታ በቅቤ አይታሽም።
  አይጥ በበላ ዳዋ ተመታ።
  ሲተረጉሙ ይደረግሙ።
  ቀስ በቀስ፥ ዕንቁላል በእግሩ ይሄዳል።
  ድር ቢያብር አንበሳ ያስር።
  ሰው እንደቤቱ እንጅ እንደ ጉረቤቱ አይተዳደርም።
  እግዜር የከፈተውን ጉሮሮ ሳይዘጋው አይድርም።
  የጎረቤት ሌባ፥ ቢያዩት ይስቅ ባያዩት ያጠልቅ።
  ሥራ ከመፍታት ልጄን ላፋታት።
  ዓባይ ማደሪያ የለው፥ ግንድ ይዞ ይዞራል።
  የእስላም አገሩ መካ የአሞራ አገሩ ዋርካ።
  ተንጋሎ ቢተፉ ተመልሶ ባፉ።
  ወዳጅህ ማር ቢሆን ጨርስህ አትላሰው።
  እግርህን በፍራሽህ ልክ ዘርጋ።

Runes:

  ᚻᛖ ᚳᚹᚫᚦ ᚦᚫᛏ ᚻᛖ ᛒᚢᛞᛖ ᚩᚾ ᚦᚫᛗ ᛚᚪᚾᛞᛖ ᚾᚩᚱᚦᚹᛖᚪᚱᛞᚢᛗ ᚹᛁᚦ ᚦᚪ ᚹᛖᛥᚫ

  (Old English, which transcribed into Latin reads 'He cwaeth that he
  bude thaem lande northweardum with tha Westsae.' and means 'He said
  that he lived in the northern land near the Western Sea.')

Braille:

  ⡌⠁⠧⠑ ⠼⠁⠒  ⡍⠜⠇⠑⠹⠰⠎ ⡣⠕⠌

  ⡍⠜⠇⠑⠹ ⠺⠁⠎ ⠙⠑⠁⠙⠒ ⠞⠕ ⠃⠑⠛⠔ ⠺⠊⠹⠲ ⡹⠻⠑ ⠊⠎ ⠝⠕ ⠙⠳⠃⠞
  ⠱⠁⠞⠑⠧⠻ ⠁⠃⠳⠞ ⠹⠁⠞⠲ ⡹⠑ ⠗⠑⠛⠊⠌⠻ ⠕⠋ ⠙⠊⠎ ⠃⠥⠗⠊⠁⠇ ⠺⠁⠎
  ⠎⠊⠛⠝⠫ ⠃⠹ ⠹⠑ ⠊⠇⠻⠛⠹⠍⠁⠝⠂ ⠹⠑ ⠊⠇⠻⠅⠂ ⠹⠑ ⠥⠝⠙⠻⠞⠁⠅⠻⠂
  ⠁⠝⠙ ⠹⠑ ⠡⠊⠑⠋ ⠍⠳⠗⠝⠻⠲ ⡎⠊⠗⠕⠕⠛⠑ ⠎⠊⠛⠝⠫ ⠊⠞⠲ ⡁⠝⠙
  ⡎⠊⠗⠕⠕⠛⠑⠰⠎ ⠝⠁⠍⠑ ⠺⠁⠎ ⠛⠕⠕⠙ ⠥⠏⠕⠝ ⠰⡡⠁⠝⠛⠑⠂ ⠋⠕⠗ ⠁⠝⠹⠹⠔⠛ ⠙⠑
  ⠡⠕⠎⠑ ⠞⠕ ⠏⠥⠞ ⠙⠊⠎ ⠙⠁⠝⠙ ⠞⠕⠲

  ⡕⠇⠙ ⡍⠜⠇⠑⠹ ⠺⠁⠎ ⠁⠎ ⠙⠑⠁⠙ ⠁⠎ ⠁ ⠙⠕⠕⠗⠤⠝⠁⠊⠇⠲

  ⡍⠔⠙⠖ ⡊ ⠙⠕⠝⠰⠞ ⠍⠑⠁⠝ ⠞⠕ ⠎⠁⠹ ⠹⠁⠞ ⡊ ⠅⠝⠪⠂ ⠕⠋ ⠍⠹
  ⠪⠝ ⠅⠝⠪⠇⠫⠛⠑⠂ ⠱⠁⠞ ⠹⠻⠑ ⠊⠎ ⠏⠜⠞⠊⠊⠥⠇⠜⠇⠹ ⠙⠑⠁⠙ ⠁⠃⠳⠞
  ⠁ ⠙⠕⠕⠗⠤⠝⠁⠊⠇⠲ ⡊ ⠍⠊⠣⠞ ⠙⠁⠧⠑ ⠃⠑⠲ ⠔⠊⠇⠔⠫⠂ ⠍⠹⠎⠑⠇⠋⠂ ⠞⠕
  ⠗⠑⠛⠜⠙ ⠁ ⠊⠕⠋⠋⠔⠤⠝⠁⠊⠇ ⠁⠎ ⠹⠑ ⠙⠑⠁⠙⠑⠌ ⠏⠊⠑⠊⠑ ⠕⠋ ⠊⠗⠕⠝⠍⠕⠝⠛⠻⠹
  ⠔ ⠹⠑ ⠞⠗⠁⠙⠑⠲ ⡃⠥⠞ ⠹⠑ ⠺⠊⠎⠙⠕⠍ ⠕⠋ ⠳⠗ ⠁⠝⠊⠑⠌⠕⠗⠎
  ⠊⠎ ⠔ ⠹⠑ ⠎⠊⠍⠊⠇⠑⠆ ⠁⠝⠙ ⠍⠹ ⠥⠝⠙⠁⠇⠇⠪⠫ ⠙⠁⠝⠙⠎
  ⠩⠁⠇⠇ ⠝⠕⠞ ⠙⠊⠌⠥⠗⠃ ⠊⠞⠂ ⠕⠗ ⠹⠑ ⡊⠳⠝⠞⠗⠹⠰⠎ ⠙⠕⠝⠑ ⠋⠕⠗⠲ ⡹⠳
  ⠺⠊⠇⠇ ⠹⠻⠑⠋⠕⠗⠑ ⠏⠻⠍⠊⠞ ⠍⠑ ⠞⠕ ⠗⠑⠏⠑⠁⠞⠂ ⠑⠍⠏⠙⠁⠞⠊⠊⠁⠇⠇⠹⠂ ⠹⠁⠞
  ⡍⠜⠇⠑⠹ ⠺⠁⠎ ⠁⠎ ⠙⠑⠁⠙ ⠁⠎ ⠁ ⠙⠕⠕⠗⠤⠝⠁⠊⠇⠲

  (The first couple of paragraphs of "A Christmas Carol" by Dickens)

Compact font selection example text:

  ABCDEFGHIJKLMNOPQRSTUVWXYZ /0123456789
  abcdefghijklmnopqrstuvwxyz £©µÀÆÖÞßéöÿ
  –—‘“”„†•…‰™œŠŸž€ ΑΒΓΔΩαβγδω АБВГДабвгд
  ∀∂∈ℝ∧∪≡∞ ↑↗↨↻⇣ ┐┼╔╘░►☺♀ ﬁ�⑀₂ἠḂӥẄɐː⍎אԱა

Greetings in various languages:

  Hello world, Καλημέρα κόσμε, コンニチハ

Box drawing alignment tests:                                          █
                                                                      ▉
  ╔══╦══╗  ┌──┬──┐  ╭──┬──╮  ╭──┬──╮  ┏━━┳━━┓  ┎┒┏┑   ╷  ╻ ┏┯┓ ┌┰┐    ▊ ╱╲╱╲╳╳╳
  ║┌─╨─┐║  │╔═╧═╗│  │╒═╪═╕│  │╓─╁─╖│  ┃┌─╂─┐┃  ┗╃╄┙  ╶┼╴╺╋╸┠┼┨ ┝╋┥    ▋ ╲╱╲╱╳╳╳
  ║│╲ ╱│║  │║   ║│  ││ │ ││  │║ ┃ ║│  ┃│ ╿ │┃  ┍╅╆┓   ╵  ╹ ┗┷┛ └┸┘    ▌ ╱╲╱╲╳╳╳
  ╠╡ ╳ ╞╣  ├╢   ╟┤  ├┼─┼─┼┤  ├╫─╂─╫┤  ┣┿╾┼╼┿┫  ┕┛┖┚     ┌┄┄┐ ╎ ┏┅┅┓ ┋ ▍ ╲╱╲╱╳╳╳
  ║│╱ ╲│║  │║   ║│  ││ │ ││  │║ ┃ ║│  ┃│ ╽ │┃  ░░▒▒▓▓██ ┊  ┆ ╎ ╏  ┇ ┋ ▎
  ║└─╥─┘║  │╚═╤═╝│  │╘═╪═╛│  │╙─╀─╜│  ┃└─╂─┘┃  ░░▒▒▓▓██ ┊  ┆ ╎ ╏  ┇ ┋ ▏
  ╚══╩══╝  └──┴──┘  ╰──┴──╯  ╰──┴──╯  ┗━━┻━━┛  ▗▄▖▛▀▜   └╌╌┘ ╎ ┗╍╍┛ ┋  ▁▂▃▄▅▆▇█
                                               ▝▀▘▙▄▟
__[ YAML::XS result ]__
---
- - 0
  - UTF-8
- - 0
  - encoded
- - 0
  - sample
- - 0
  - plain-text
- - 0
  - file
- - 0
  - ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
- - 0
  - markus
- - 0
  - kuhn
- - 1
  - '['
- - 0
  - ˈmaʳkʊs
- - 0
  - kuːn
- - 2
  - ']'
- - 1
  - <
- - 0
  - http://www.cl.cam.ac.uk/~mgk25/
- - 2
  - '>'
- - 0
  - —
- - 0
  - 2002-07-25
- - 0
  - the
- - 0
  - ASCII
- - 0
  - compatible
- - 0
  - UTF-8
- - 0
  - encoding
- - 0
  - used
- - 0
  - in
- - 0
  - this
- - 0
  - plain-text
- - 0
  - file
- - 0
  - is
- - 0
  - defined
- - 0
  - in
- - 0
  - unicode
- - 2
  - ','
- - 0
  - ISO
- - 0
  - 10646-1
- - 2
  - ','
- - 0
  - and
- - 0
  - RFC
- - 0
  - '2279'
- - 2
  - .
- - 0
  - using
- - 0
  - unicode
- - 3
  - /
- - 0
  - UTF-8
- - 2
  - ','
- - 0
  - you
- - 0
  - can
- - 0
  - write
- - 0
  - in
- - 0
  - emails
- - 0
  - and
- - 0
  - source
- - 0
  - code
- - 0
  - things
- - 0
  - such
- - 0
  - as
- - 0
  - mathematics
- - 0
  - and
- - 0
  - sciences
- - 2
  - ':'
- - 0
  - ∮
- - 0
  - E
- - 3
  - ⋅
- - 0
  - da
- - 0
  - =
- - 0
  - Q
- - 2
  - ','
- - 0
  - n
- - 0
  - →
- - 0
  - ∞,
- - 0
  - ∑
- - 0
  - f
- - 3
  - (
- - 0
  - i
- - 2
  - )
- - 0
  - =
- - 0
  - ∏
- - 0
  - g
- - 3
  - (
- - 0
  - i
- - 2
  - ),
- - 0
  - ⎧⎡⎛┌─────┐⎞⎤⎫
- - 1
  - ⎪⎢⎜│
- - 0
  - a
- - 3
  - ²+
- - 0
  - b
- - 2
  - ³
- - 0
  - ⎟⎥⎪
- - 1
  - ∀
- - 0
  - x
- - 3
  - ∈
- - 0
  - ℝ
- - 2
  - ':'
- - 1
  - ⌈
- - 0
  - x
- - 2
  - ⌉
- - 0
  - =
- - 1
  - −⌊−
- - 0
  - x
- - 2
  - ⌋,
- - 0
  - α
- - 0
  - ∧
- - 1
  - ¬
- - 0
  - β
- - 0
  - =
- - 1
  - ¬(¬
- - 0
  - α
- - 0
  - ∨
- - 0
  - β
- - 2
  - ),
- - 0
  - ⎪⎢⎜│─────
- - 0
  - ⎟⎥⎪
- - 0
  - ⎪⎢⎜⎷
- - 0
  - c
- - 2
  - ₈
- - 0
  - ⎟⎥⎪
- - 0
  - ℕ
- - 0
  - ⊆
- - 0
  - ℕ
- - 2
  - ₀
- - 0
  - ⊂
- - 0
  - ℤ
- - 0
  - ⊂
- - 0
  - ℚ
- - 0
  - ⊂
- - 0
  - ℝ
- - 0
  - ⊂
- - 0
  - ℂ
- - 2
  - ','
- - 0
  - ⎨⎢⎜
- - 0
  - ⎟⎥⎬
- - 0
  - ⎪⎢⎜
- - 0
  - ∞
- - 0
  - ⎟⎥⎪
- - 0
  - ⊥
- - 0
  - <
- - 0
  - a
- - 0
  - ≠
- - 0
  - b
- - 0
  - ≡
- - 0
  - c
- - 0
  - ≤
- - 0
  - d
- - 0
  - ≪
- - 0
  - ⊤
- - 0
  - ⇒
- - 1
  - (⟦
- - 0
  - A
- - 2
  - ⟧
- - 0
  - ⇔
- - 1
  - ⟪
- - 0
  - B
- - 2
  - ⟫),
- - 0
  - ⎪⎢⎜
- - 0
  - ⎲
- - 0
  - ⎟⎥⎪
- - 0
  - ⎪⎢⎜
- - 1
  - ⎳
- - 0
  - aⁱ-bⁱ
- - 2
  - ⎟⎥⎪
- - 0
  - 2H
- - 2
  - ₂
- - 0
  - +
- - 0
  - O
- - 2
  - ₂
- - 0
  - ⇌
- - 0
  - 2H
- - 3
  - ₂
- - 0
  - O
- - 2
  - ','
- - 0
  - R
- - 0
  - =
- - 0
  - '4.7'
- - 0
  - kΩ
- - 2
  - ','
- - 0
  - ⌀
- - 0
  - '200'
- - 0
  - mm
- - 1
  - ⎩⎣⎝
- - 0
  - i
- - 3
  - =
- - 0
  - '1'
- - 0
  - ⎠⎦⎭
- - 0
  - linguistics
- - 0
  - and
- - 0
  - dictionaries
- - 2
  - ':'
- - 0
  - ði
- - 0
  - ıntəˈnæʃənəl
- - 0
  - fəˈnɛtık
- - 0
  - əsoʊsiˈeıʃn
- - 0
  - Y
- - 1
  - '['
- - 0
  - ˈʏpsilɔn
- - 2
  - '],'
- - 0
  - yen
- - 1
  - '['
- - 0
  - jɛn
- - 2
  - '],'
- - 0
  - yoga
- - 1
  - '['
- - 0
  - ˈjoːgɑ
- - 2
  - ']'
- - 0
  - APL
- - 2
  - ':'
- - 1
  - ((
- - 0
  - V
- - 3
  - ⍳
- - 0
  - V
- - 3
  - )=⍳⍴
- - 0
  - V
- - 3
  - )/
- - 0
  - V
- - 3
  - ←,
- - 0
  - V
- - 0
  - ⌷←⍳→⍴∆∇⊃‾⍎⍕⌈
- - 0
  - nicer
- - 0
  - typography
- - 0
  - in
- - 0
  - plain
- - 0
  - text
- - 0
  - files
- - 2
  - ':'
- - 0
  - ╔══════════════════════════════════════════╗
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - •
- - 1
  - ‘
- - 0
  - single
- - 2
  - ’
- - 0
  - and
- - 1
  - “
- - 0
  - double
- - 2
  - ”
- - 0
  - quotes
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - •
- - 0
  - curly
- - 0
  - apostrophes
- - 2
  - ':'
- - 1
  - “
- - 0
  - we’ve
- - 0
  - been
- - 0
  - here
- - 2
  - ”
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - •
- - 0
  - latin-1
- - 0
  - apostrophe
- - 0
  - and
- - 0
  - accents
- - 2
  - ':'
- - 0
  - '''´`'
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - •
- - 1
  - ‚
- - 0
  - deutsche
- - 2
  - ‘
- - 1
  - „
- - 0
  - anführungszeichen
- - 2
  - “
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - •
- - 0
  - †,
- - 0
  - ‡,
- - 0
  - ‰,
- - 0
  - •,
- - 0
  - 3–4
- - 2
  - ','
- - 0
  - —,
- - 1
  - −
- - 0
  - '5'
- - 3
  - /+
- - 0
  - '5'
- - 2
  - ','
- - 0
  - ™,
- - 0
  - …
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - ║
- - 0
  - •
- - 0
  - ASCII
- - 0
  - safety
- - 0
  - test
- - 2
  - ':'
- - 0
  - 1lI
- - 2
  - '|,'
- - 0
  - 0OD
- - 2
  - ','
- - 0
  - 8B
- - 0
  - ║
- - 0
  - ║
- - 0
  - ╭─────────╮
- - 0
  - ║
- - 0
  - ║
- - 0
  - •
- - 0
  - the
- - 0
  - euro
- - 0
  - symbol
- - 2
  - ':'
- - 0
  - │
- - 0
  - '14.95'
- - 0
  - €
- - 0
  - │
- - 0
  - ║
- - 0
  - ║
- - 0
  - ╰─────────╯
- - 0
  - ║
- - 0
  - ╚══════════════════════════════════════════╝
- - 0
  - combining
- - 0
  - characters
- - 2
  - ':'
- - 0
  - STARGΛ̊TE
- - 0
  - SG-1
- - 2
  - ','
- - 0
  - a
- - 0
  - =
- - 0
  - v̇
- - 0
  - =
- - 0
  - r̈
- - 2
  - ','
- - 0
  - a⃑
- - 0
  - ⊥
- - 0
  - b⃑
- - 0
  - greek
- - 1
  - (
- - 0
  - in
- - 0
  - polytonic
- - 2
  - '):'
- - 0
  - the
- - 0
  - greek
- - 0
  - anthem
- - 2
  - ':'
- - 0
  - σὲ
- - 0
  - γνωρίζω
- - 0
  - ἀπὸ
- - 0
  - τὴν
- - 0
  - κόψη
- - 0
  - τοῦ
- - 0
  - σπαθιοῦ
- - 0
  - τὴν
- - 0
  - τρομερή
- - 2
  - ','
- - 0
  - σὲ
- - 0
  - γνωρίζω
- - 0
  - ἀπὸ
- - 0
  - τὴν
- - 0
  - ὄψη
- - 0
  - ποὺ
- - 0
  - μὲ
- - 0
  - βία
- - 0
  - μετράει
- - 0
  - τὴ
- - 0
  - γῆ
- - 2
  - .
- - 1
  - ᾿
- - 0
  - απ
- - 2
  - ᾿
- - 0
  - τὰ
- - 0
  - κόκκαλα
- - 0
  - βγαλμένη
- - 0
  - τῶν
- - 1
  - ῾
- - 0
  - ελλήνων
- - 0
  - τὰ
- - 0
  - ἱερά
- - 0
  - καὶ
- - 0
  - σὰν
- - 0
  - πρῶτα
- - 0
  - ἀνδρειωμένη
- - 0
  - χαῖρε
- - 2
  - ','
- - 0
  - ὦ
- - 0
  - χαῖρε
- - 2
  - ','
- - 1
  - ᾿
- - 0
  - ελευθεριά
- - 2
  - '!'
- - 0
  - from
- - 0
  - a
- - 0
  - speech
- - 0
  - of
- - 0
  - demosthenes
- - 0
  - in
- - 0
  - the
- - 0
  - 4th
- - 0
  - century
- - 0
  - BC
- - 2
  - ':'
- - 0
  - οὐχὶ
- - 0
  - ταὐτὰ
- - 0
  - παρίσταταί
- - 0
  - μοι
- - 0
  - γιγνώσκειν
- - 2
  - ','
- - 0
  - ὦ
- - 0
  - ἄνδρες
- - 1
  - ᾿
- - 0
  - αθηναῖοι
- - 2
  - ','
- - 0
  - ὅταν
- - 0
  - τ
- - 2
  - ᾿
- - 0
  - εἰς
- - 0
  - τὰ
- - 0
  - πράγματα
- - 0
  - ἀποβλέψω
- - 0
  - καὶ
- - 0
  - ὅταν
- - 0
  - πρὸς
- - 0
  - τοὺς
- - 0
  - λόγους
- - 0
  - οὓς
- - 0
  - ἀκούω
- - 2
  - ·
- - 0
  - τοὺς
- - 0
  - μὲν
- - 0
  - γὰρ
- - 0
  - λόγους
- - 0
  - περὶ
- - 0
  - τοῦ
- - 0
  - τιμωρήσασθαι
- - 0
  - φίλιππον
- - 0
  - ὁρῶ
- - 0
  - γιγνομένους
- - 2
  - ','
- - 0
  - τὰ
- - 0
  - δὲ
- - 0
  - πράγματ
- - 2
  - ᾿
- - 0
  - εἰς
- - 0
  - τοῦτο
- - 0
  - προήκοντα
- - 2
  - ','
- - 0
  - ὥσθ
- - 2
  - ᾿
- - 0
  - ὅπως
- - 0
  - μὴ
- - 0
  - πεισόμεθ
- - 2
  - ᾿
- - 0
  - αὐτοὶ
- - 0
  - πρότερον
- - 0
  - κακῶς
- - 0
  - σκέψασθαι
- - 0
  - δέον
- - 2
  - .
- - 0
  - οὐδέν
- - 0
  - οὖν
- - 0
  - ἄλλο
- - 0
  - μοι
- - 0
  - δοκοῦσιν
- - 0
  - οἱ
- - 0
  - τὰ
- - 0
  - τοιαῦτα
- - 0
  - λέγοντες
- - 0
  - ἢ
- - 0
  - τὴν
- - 0
  - ὑπόθεσιν
- - 2
  - ','
- - 0
  - περὶ
- - 0
  - ἧς
- - 0
  - βουλεύεσθαι
- - 2
  - ','
- - 0
  - οὐχὶ
- - 0
  - τὴν
- - 0
  - οὖσαν
- - 0
  - παριστάντες
- - 0
  - ὑμῖν
- - 0
  - ἁμαρτάνειν
- - 2
  - .
- - 0
  - ἐγὼ
- - 0
  - δέ
- - 2
  - ','
- - 0
  - ὅτι
- - 0
  - μέν
- - 0
  - ποτ
- - 2
  - ᾿
- - 0
  - ἐξῆν
- - 0
  - τῇ
- - 0
  - πόλει
- - 0
  - καὶ
- - 0
  - τὰ
- - 0
  - αὑτῆς
- - 0
  - ἔχειν
- - 0
  - ἀσφαλῶς
- - 0
  - καὶ
- - 0
  - φίλιππον
- - 0
  - τιμωρήσασθαι
- - 2
  - ','
- - 0
  - καὶ
- - 0
  - μάλ
- - 2
  - ᾿
- - 0
  - ἀκριβῶς
- - 0
  - οἶδα
- - 2
  - ·
- - 0
  - ἐπ
- - 2
  - ᾿
- - 0
  - ἐμοῦ
- - 0
  - γάρ
- - 2
  - ','
- - 0
  - οὐ
- - 0
  - πάλαι
- - 0
  - γέγονεν
- - 0
  - ταῦτ
- - 2
  - ᾿
- - 0
  - ἀμφότερα
- - 2
  - ·
- - 0
  - νῦν
- - 0
  - μέντοι
- - 0
  - πέπεισμαι
- - 0
  - τοῦθ
- - 2
  - ᾿
- - 0
  - ἱκανὸν
- - 0
  - προλαβεῖν
- - 0
  - ἡμῖν
- - 0
  - εἶναι
- - 0
  - τὴν
- - 0
  - πρώτην
- - 2
  - ','
- - 0
  - ὅπως
- - 0
  - τοὺς
- - 0
  - συμμάχους
- - 0
  - σώσομεν
- - 2
  - .
- - 0
  - ἐὰν
- - 0
  - γὰρ
- - 0
  - τοῦτο
- - 0
  - βεβαίως
- - 0
  - ὑπάρξῃ
- - 2
  - ','
- - 0
  - τότε
- - 0
  - καὶ
- - 0
  - περὶ
- - 0
  - τοῦ
- - 0
  - τίνα
- - 0
  - τιμωρήσεταί
- - 0
  - τις
- - 0
  - καὶ
- - 0
  - ὃν
- - 0
  - τρόπον
- - 0
  - ἐξέσται
- - 0
  - σκοπεῖν
- - 2
  - ·
- - 0
  - πρὶν
- - 0
  - δὲ
- - 0
  - τὴν
- - 0
  - ἀρχὴν
- - 0
  - ὀρθῶς
- - 0
  - ὑποθέσθαι
- - 2
  - ','
- - 0
  - μάταιον
- - 0
  - ἡγοῦμαι
- - 0
  - περὶ
- - 0
  - τῆς
- - 0
  - τελευτῆς
- - 0
  - ὁντινοῦν
- - 0
  - ποιεῖσθαι
- - 0
  - λόγον
- - 2
  - .
- - 0
  - δημοσθένους
- - 2
  - ','
- - 0
  - Γ
- - 2
  - ´
- - 1
  - ᾿
- - 0
  - ολυνθιακὸς
- - 0
  - georgian
- - 2
  - ':'
- - 0
  - from
- - 0
  - a
- - 0
  - unicode
- - 0
  - conference
- - 0
  - invitation
- - 2
  - ':'
- - 0
  - გთხოვთ
- - 0
  - ახლავე
- - 0
  - გაიაროთ
- - 0
  - რეგისტრაცია
- - 0
  - unicode-ის
- - 0
  - მეათე
- - 0
  - საერთაშორისო
- - 0
  - კონფერენციაზე
- - 0
  - დასასწრებად
- - 2
  - ','
- - 0
  - რომელიც
- - 0
  - გაიმართება
- - 0
  - 10-12
- - 0
  - მარტს
- - 2
  - ','
- - 0
  - ქ
- - 2
  - .
- - 0
  - მაინცში
- - 2
  - ','
- - 0
  - გერმანიაში
- - 2
  - .
- - 0
  - კონფერენცია
- - 0
  - შეჰკრებს
- - 0
  - ერთად
- - 0
  - მსოფლიოს
- - 0
  - ექსპერტებს
- - 0
  - ისეთ
- - 0
  - დარგებში
- - 0
  - როგორიცაა
- - 0
  - ინტერნეტი
- - 0
  - და
- - 0
  - unicode-ი
- - 2
  - ','
- - 0
  - ინტერნაციონალიზაცია
- - 0
  - და
- - 0
  - ლოკალიზაცია
- - 2
  - ','
- - 0
  - unicode-ის
- - 0
  - გამოყენება
- - 0
  - ოპერაციულ
- - 0
  - სისტემებსა
- - 2
  - ','
- - 0
  - და
- - 0
  - გამოყენებით
- - 0
  - პროგრამებში
- - 2
  - ','
- - 0
  - შრიფტებში
- - 2
  - ','
- - 0
  - ტექსტების
- - 0
  - დამუშავებასა
- - 0
  - და
- - 0
  - მრავალენოვან
- - 0
  - კომპიუტერულ
- - 0
  - სისტემებში
- - 2
  - .
- - 0
  - russian
- - 2
  - ':'
- - 0
  - from
- - 0
  - a
- - 0
  - unicode
- - 0
  - conference
- - 0
  - invitation
- - 2
  - ':'
- - 0
  - зарегистрируйтесь
- - 0
  - сейчас
- - 0
  - на
- - 0
  - десятую
- - 0
  - международную
- - 0
  - конференцию
- - 0
  - по
- - 0
  - unicode
- - 2
  - ','
- - 0
  - которая
- - 0
  - состоится
- - 0
  - 10-12
- - 0
  - марта
- - 0
  - '1997'
- - 0
  - года
- - 0
  - в
- - 0
  - майнце
- - 0
  - в
- - 0
  - германии
- - 2
  - .
- - 0
  - конференция
- - 0
  - соберет
- - 0
  - широкий
- - 0
  - круг
- - 0
  - экспертов
- - 0
  - по
- - 0
  - вопросам
- - 0
  - глобального
- - 0
  - интернета
- - 0
  - и
- - 0
  - unicode
- - 2
  - ','
- - 0
  - локализации
- - 0
  - и
- - 0
  - интернационализации
- - 2
  - ','
- - 0
  - воплощению
- - 0
  - и
- - 0
  - применению
- - 0
  - unicode
- - 0
  - в
- - 0
  - различных
- - 0
  - операционных
- - 0
  - системах
- - 0
  - и
- - 0
  - программных
- - 0
  - приложениях
- - 2
  - ','
- - 0
  - шрифтах
- - 2
  - ','
- - 0
  - верстке
- - 0
  - и
- - 0
  - многоязычных
- - 0
  - компьютерных
- - 0
  - системах
- - 2
  - .
- - 0
  - thai
- - 1
  - (
- - 0
  - UCS
- - 0
  - level
- - 0
  - '2'
- - 2
  - '):'
- - 0
  - excerpt
- - 0
  - from
- - 0
  - a
- - 0
  - poetry
- - 0
  - on
- - 0
  - the
- - 0
  - romance
- - 0
  - of
- - 0
  - the
- - 0
  - three
- - 0
  - kingdoms
- - 1
  - (
- - 0
  - a
- - 0
  - chinese
- - 0
  - classic
- - 1
  - ''''
- - 0
  - san
- - 0
  - gua
- - 2
  - '''):'
- - 0
  - '[----------------------------|------------------------]'
- - 0
  - ๏
- - 0
  - แผ่นดินฮั่นเสื่อมโทรมแสนสังเวช
- - 0
  - พระปกเกศกองบู๊กู้ขึ้นใหม่
- - 0
  - สิบสองกษัตริย์ก่อนหน้าแลถัดไป
- - 0
  - สององค์ไซร้โง่เขลาเบาปัญญา
- - 0
  - ทรงนับถือขันทีเป็นที่พึ่ง
- - 0
  - บ้านเมืองจึงวิปริตเป็นนักหนา
- - 0
  - โฮจิ๋นเรียกทัพทั่วหัวเมืองมา
- - 0
  - หมายจะฆ่ามดชั่วตัวสำคัญ
- - 0
  - เหมือนขับไสไล่เสือจากเคหา
- - 0
  - รับหมาป่าเข้ามาเลยอาสัญ
- - 0
  - ฝ่ายอ้องอุ้นยุแยกให้แตกกัน
- - 0
  - ใช้สาวนั้นเป็นชนวนชื่นชวนใจ
- - 0
  - พลันลิฉุยกุยกีกลับก่อเหตุ
- - 0
  - ช่างอาเพศจริงหนาฟ้าร้องไห้
- - 0
  - ต้องรบราฆ่าฟันจนบรรลัย
- - 0
  - ฤๅหาใครค้ำชูกู้บรรลังก์
- - 0
  - ฯ
- - 1
  - (
- - 0
  - the
- - 0
  - above
- - 0
  - is
- - 0
  - a
- - 0
  - two-column
- - 0
  - text
- - 2
  - .
- - 0
  - if
- - 0
  - combining
- - 0
  - characters
- - 0
  - are
- - 0
  - handled
- - 0
  - correctly
- - 2
  - ','
- - 0
  - the
- - 0
  - lines
- - 0
  - of
- - 0
  - the
- - 0
  - second
- - 0
  - column
- - 0
  - should
- - 0
  - be
- - 0
  - aligned
- - 0
  - with
- - 0
  - the
- - 0
  - '|'
- - 0
  - character
- - 0
  - above
- - 2
  - .)
- - 0
  - ethiopian
- - 2
  - ':'
- - 0
  - proverbs
- - 0
  - in
- - 0
  - the
- - 0
  - amharic
- - 0
  - language
- - 2
  - ':'
- - 0
  - ሰማይ
- - 0
  - አይታረስ
- - 0
  - ንጉሥ
- - 0
  - አይከሰስ
- - 2
  - ።
- - 0
  - ብላ
- - 0
  - ካለኝ
- - 0
  - እንደአባቴ
- - 0
  - በቆመጠኝ
- - 2
  - ።
- - 0
  - ጌጥ
- - 0
  - ያለቤቱ
- - 0
  - ቁምጥና
- - 0
  - ነው
- - 2
  - ።
- - 0
  - ደሀ
- - 0
  - በሕልሙ
- - 0
  - ቅቤ
- - 0
  - ባይጠጣ
- - 0
  - ንጣት
- - 0
  - በገደለው
- - 2
  - ።
- - 0
  - የአፍ
- - 0
  - ወለምታ
- - 0
  - በቅቤ
- - 0
  - አይታሽም
- - 2
  - ።
- - 0
  - አይጥ
- - 0
  - በበላ
- - 0
  - ዳዋ
- - 0
  - ተመታ
- - 2
  - ።
- - 0
  - ሲተረጉሙ
- - 0
  - ይደረግሙ
- - 2
  - ።
- - 0
  - ቀስ
- - 0
  - በቀስ
- - 2
  - ፥
- - 0
  - ዕንቁላል
- - 0
  - በእግሩ
- - 0
  - ይሄዳል
- - 2
  - ።
- - 0
  - ድር
- - 0
  - ቢያብር
- - 0
  - አንበሳ
- - 0
  - ያስር
- - 2
  - ።
- - 0
  - ሰው
- - 0
  - እንደቤቱ
- - 0
  - እንጅ
- - 0
  - እንደ
- - 0
  - ጉረቤቱ
- - 0
  - አይተዳደርም
- - 2
  - ።
- - 0
  - እግዜር
- - 0
  - የከፈተውን
- - 0
  - ጉሮሮ
- - 0
  - ሳይዘጋው
- - 0
  - አይድርም
- - 2
  - ።
- - 0
  - የጎረቤት
- - 0
  - ሌባ
- - 2
  - ፥
- - 0
  - ቢያዩት
- - 0
  - ይስቅ
- - 0
  - ባያዩት
- - 0
  - ያጠልቅ
- - 2
  - ።
- - 0
  - ሥራ
- - 0
  - ከመፍታት
- - 0
  - ልጄን
- - 0
  - ላፋታት
- - 2
  - ።
- - 0
  - ዓባይ
- - 0
  - ማደሪያ
- - 0
  - የለው
- - 2
  - ፥
- - 0
  - ግንድ
- - 0
  - ይዞ
- - 0
  - ይዞራል
- - 2
  - ።
- - 0
  - የእስላም
- - 0
  - አገሩ
- - 0
  - መካ
- - 0
  - የአሞራ
- - 0
  - አገሩ
- - 0
  - ዋርካ
- - 2
  - ።
- - 0
  - ተንጋሎ
- - 0
  - ቢተፉ
- - 0
  - ተመልሶ
- - 0
  - ባፉ
- - 2
  - ።
- - 0
  - ወዳጅህ
- - 0
  - ማር
- - 0
  - ቢሆን
- - 0
  - ጨርስህ
- - 0
  - አትላሰው
- - 2
  - ።
- - 0
  - እግርህን
- - 0
  - በፍራሽህ
- - 0
  - ልክ
- - 0
  - ዘርጋ
- - 2
  - ።
- - 0
  - runes
- - 2
  - ':'
- - 0
  - ᚻᛖ
- - 0
  - ᚳᚹᚫᚦ
- - 0
  - ᚦᚫᛏ
- - 0
  - ᚻᛖ
- - 0
  - ᛒᚢᛞᛖ
- - 0
  - ᚩᚾ
- - 0
  - ᚦᚫᛗ
- - 0
  - ᛚᚪᚾᛞᛖ
- - 0
  - ᚾᚩᚱᚦᚹᛖᚪᚱᛞᚢᛗ
- - 0
  - ᚹᛁᚦ
- - 0
  - ᚦᚪ
- - 0
  - ᚹᛖᛥᚫ
- - 1
  - (
- - 0
  - old
- - 0
  - english
- - 2
  - ','
- - 0
  - which
- - 0
  - transcribed
- - 0
  - into
- - 0
  - latin
- - 0
  - reads
- - 1
  - ''''
- - 0
  - he
- - 0
  - cwaeth
- - 0
  - that
- - 0
  - he
- - 0
  - bude
- - 0
  - thaem
- - 0
  - lande
- - 0
  - northweardum
- - 0
  - with
- - 0
  - tha
- - 0
  - westsae
- - 2
  - .'
- - 0
  - and
- - 0
  - means
- - 1
  - ''''
- - 0
  - he
- - 0
  - said
- - 0
  - that
- - 0
  - he
- - 0
  - lived
- - 0
  - in
- - 0
  - the
- - 0
  - northern
- - 0
  - land
- - 0
  - near
- - 0
  - the
- - 0
  - western
- - 0
  - sea
- - 2
  - .')
- - 0
  - braille
- - 2
  - ':'
- - 0
  - ⡌⠁⠧⠑
- - 0
  - ⠼⠁⠒
- - 0
  - ⡍⠜⠇⠑⠹⠰⠎
- - 0
  - ⡣⠕⠌
- - 0
  - ⡍⠜⠇⠑⠹
- - 0
  - ⠺⠁⠎
- - 0
  - ⠙⠑⠁⠙⠒
- - 0
  - ⠞⠕
- - 0
  - ⠃⠑⠛⠔
- - 0
  - ⠺⠊⠹⠲
- - 0
  - ⡹⠻⠑
- - 0
  - ⠊⠎
- - 0
  - ⠝⠕
- - 0
  - ⠙⠳⠃⠞
- - 0
  - ⠱⠁⠞⠑⠧⠻
- - 0
  - ⠁⠃⠳⠞
- - 0
  - ⠹⠁⠞⠲
- - 0
  - ⡹⠑
- - 0
  - ⠗⠑⠛⠊⠌⠻
- - 0
  - ⠕⠋
- - 0
  - ⠙⠊⠎
- - 0
  - ⠃⠥⠗⠊⠁⠇
- - 0
  - ⠺⠁⠎
- - 0
  - ⠎⠊⠛⠝⠫
- - 0
  - ⠃⠹
- - 0
  - ⠹⠑
- - 0
  - ⠊⠇⠻⠛⠹⠍⠁⠝⠂
- - 0
  - ⠹⠑
- - 0
  - ⠊⠇⠻⠅⠂
- - 0
  - ⠹⠑
- - 0
  - ⠥⠝⠙⠻⠞⠁⠅⠻⠂
- - 0
  - ⠁⠝⠙
- - 0
  - ⠹⠑
- - 0
  - ⠡⠊⠑⠋
- - 0
  - ⠍⠳⠗⠝⠻⠲
- - 0
  - ⡎⠊⠗⠕⠕⠛⠑
- - 0
  - ⠎⠊⠛⠝⠫
- - 0
  - ⠊⠞⠲
- - 0
  - ⡁⠝⠙
- - 0
  - ⡎⠊⠗⠕⠕⠛⠑⠰⠎
- - 0
  - ⠝⠁⠍⠑
- - 0
  - ⠺⠁⠎
- - 0
  - ⠛⠕⠕⠙
- - 0
  - ⠥⠏⠕⠝
- - 0
  - ⠰⡡⠁⠝⠛⠑⠂
- - 0
  - ⠋⠕⠗
- - 0
  - ⠁⠝⠹⠹⠔⠛
- - 0
  - ⠙⠑
- - 0
  - ⠡⠕⠎⠑
- - 0
  - ⠞⠕
- - 0
  - ⠏⠥⠞
- - 0
  - ⠙⠊⠎
- - 0
  - ⠙⠁⠝⠙
- - 0
  - ⠞⠕⠲
- - 0
  - ⡕⠇⠙
- - 0
  - ⡍⠜⠇⠑⠹
- - 0
  - ⠺⠁⠎
- - 0
  - ⠁⠎
- - 0
  - ⠙⠑⠁⠙
- - 0
  - ⠁⠎
- - 0
  - ⠁
- - 0
  - ⠙⠕⠕⠗⠤⠝⠁⠊⠇⠲
- - 0
  - ⡍⠔⠙⠖
- - 0
  - ⡊
- - 0
  - ⠙⠕⠝⠰⠞
- - 0
  - ⠍⠑⠁⠝
- - 0
  - ⠞⠕
- - 0
  - ⠎⠁⠹
- - 0
  - ⠹⠁⠞
- - 0
  - ⡊
- - 0
  - ⠅⠝⠪⠂
- - 0
  - ⠕⠋
- - 0
  - ⠍⠹
- - 0
  - ⠪⠝
- - 0
  - ⠅⠝⠪⠇⠫⠛⠑⠂
- - 0
  - ⠱⠁⠞
- - 0
  - ⠹⠻⠑
- - 0
  - ⠊⠎
- - 0
  - ⠏⠜⠞⠊⠊⠥⠇⠜⠇⠹
- - 0
  - ⠙⠑⠁⠙
- - 0
  - ⠁⠃⠳⠞
- - 0
  - ⠁
- - 0
  - ⠙⠕⠕⠗⠤⠝⠁⠊⠇⠲
- - 0
  - ⡊
- - 0
  - ⠍⠊⠣⠞
- - 0
  - ⠙⠁⠧⠑
- - 0
  - ⠃⠑⠲
- - 0
  - ⠔⠊⠇⠔⠫⠂
- - 0
  - ⠍⠹⠎⠑⠇⠋⠂
- - 0
  - ⠞⠕
- - 0
  - ⠗⠑⠛⠜⠙
- - 0
  - ⠁
- - 0
  - ⠊⠕⠋⠋⠔⠤⠝⠁⠊⠇
- - 0
  - ⠁⠎
- - 0
  - ⠹⠑
- - 0
  - ⠙⠑⠁⠙⠑⠌
- - 0
  - ⠏⠊⠑⠊⠑
- - 0
  - ⠕⠋
- - 0
  - ⠊⠗⠕⠝⠍⠕⠝⠛⠻⠹
- - 0
  - ⠔
- - 0
  - ⠹⠑
- - 0
  - ⠞⠗⠁⠙⠑⠲
- - 0
  - ⡃⠥⠞
- - 0
  - ⠹⠑
- - 0
  - ⠺⠊⠎⠙⠕⠍
- - 0
  - ⠕⠋
- - 0
  - ⠳⠗
- - 0
  - ⠁⠝⠊⠑⠌⠕⠗⠎
- - 0
  - ⠊⠎
- - 0
  - ⠔
- - 0
  - ⠹⠑
- - 0
  - ⠎⠊⠍⠊⠇⠑⠆
- - 0
  - ⠁⠝⠙
- - 0
  - ⠍⠹
- - 0
  - ⠥⠝⠙⠁⠇⠇⠪⠫
- - 0
  - ⠙⠁⠝⠙⠎
- - 0
  - ⠩⠁⠇⠇
- - 0
  - ⠝⠕⠞
- - 0
  - ⠙⠊⠌⠥⠗⠃
- - 0
  - ⠊⠞⠂
- - 0
  - ⠕⠗
- - 0
  - ⠹⠑
- - 0
  - ⡊⠳⠝⠞⠗⠹⠰⠎
- - 0
  - ⠙⠕⠝⠑
- - 0
  - ⠋⠕⠗⠲
- - 0
  - ⡹⠳
- - 0
  - ⠺⠊⠇⠇
- - 0
  - ⠹⠻⠑⠋⠕⠗⠑
- - 0
  - ⠏⠻⠍⠊⠞
- - 0
  - ⠍⠑
- - 0
  - ⠞⠕
- - 0
  - ⠗⠑⠏⠑⠁⠞⠂
- - 0
  - ⠑⠍⠏⠙⠁⠞⠊⠊⠁⠇⠇⠹⠂
- - 0
  - ⠹⠁⠞
- - 0
  - ⡍⠜⠇⠑⠹
- - 0
  - ⠺⠁⠎
- - 0
  - ⠁⠎
- - 0
  - ⠙⠑⠁⠙
- - 0
  - ⠁⠎
- - 0
  - ⠁
- - 0
  - ⠙⠕⠕⠗⠤⠝⠁⠊⠇⠲
- - 1
  - (
- - 0
  - the
- - 0
  - first
- - 0
  - couple
- - 0
  - of
- - 0
  - paragraphs
- - 0
  - of
- - 1
  - '"'
- - 0
  - A
- - 0
  - christmas
- - 0
  - carol
- - 2
  - '"'
- - 0
  - by
- - 0
  - dickens
- - 2
  - )
- - 0
  - compact
- - 0
  - font
- - 0
  - selection
- - 0
  - example
- - 0
  - text
- - 2
  - ':'
- - 0
  - ABCDEFGHIJKLMNOPQRSTUVWXYZ
- - 0
  - /0123456789
- - 0
  - abcdefghijklmnopqrstuvwxyz
- - 1
  - £©
- - 0
  - µÀÆÖÞßéöÿ
- - 1
  - –—‘“”„†•…‰™
- - 0
  - œŠŸž
- - 2
  - €
- - 0
  - ΑΒΓΔΩαβγδω
- - 0
  - АБВГДабвгд
- - 1
  - ∀∂∈
- - 0
  - ℝ
- - 2
  - ∧∪≡∞
- - 0
  - ↑↗↨↻⇣
- - 0
  - ┐┼╔╘░►☺♀
- - 0
  - ﬁ
- - 3
  - �⑀₂
- - 0
  - ἠḂӥẄɐː
- - 3
  - ⍎
- - 0
  - אԱა
- - 0
  - greetings
- - 0
  - in
- - 0
  - various
- - 0
  - languages
- - 2
  - ':'
- - 0
  - hello
- - 0
  - world
- - 2
  - ','
- - 0
  - καλημέρα
- - 0
  - κόσμε
- - 2
  - ','
- - 0
  - コンニチハ
- - 0
  - box
- - 0
  - drawing
- - 0
  - alignment
- - 0
  - tests
- - 2
  - ':'
- - 0
  - █
- - 0
  - ▉
- - 0
  - ╔══╦══╗
- - 0
  - ┌──┬──┐
- - 0
  - ╭──┬──╮
- - 0
  - ╭──┬──╮
- - 0
  - ┏━━┳━━┓
- - 0
  - ┎┒┏┑
- - 0
  - ╷
- - 0
  - ╻
- - 0
  - ┏┯┓
- - 0
  - ┌┰┐
- - 0
  - ▊
- - 0
  - ╱╲╱╲╳╳╳
- - 0
  - ║┌─╨─┐║
- - 0
  - │╔═╧═╗│
- - 0
  - │╒═╪═╕│
- - 0
  - │╓─╁─╖│
- - 0
  - ┃┌─╂─┐┃
- - 0
  - ┗╃╄┙
- - 0
  - ╶┼╴╺╋╸┠┼┨
- - 0
  - ┝╋┥
- - 0
  - ▋
- - 0
  - ╲╱╲╱╳╳╳
- - 0
  - ║│╲
- - 0
  - ╱│║
- - 0
  - │║
- - 0
  - ║│
- - 0
  - ││
- - 0
  - │
- - 0
  - ││
- - 0
  - │║
- - 0
  - ┃
- - 0
  - ║│
- - 0
  - ┃│
- - 0
  - ╿
- - 0
  - │┃
- - 0
  - ┍╅╆┓
- - 0
  - ╵
- - 0
  - ╹
- - 0
  - ┗┷┛
- - 0
  - └┸┘
- - 0
  - ▌
- - 0
  - ╱╲╱╲╳╳╳
- - 0
  - ╠╡
- - 0
  - ╳
- - 0
  - ╞╣
- - 0
  - ├╢
- - 0
  - ╟┤
- - 0
  - ├┼─┼─┼┤
- - 0
  - ├╫─╂─╫┤
- - 0
  - ┣┿╾┼╼┿┫
- - 0
  - ┕┛┖┚
- - 0
  - ┌┄┄┐
- - 0
  - ╎
- - 0
  - ┏┅┅┓
- - 0
  - ┋
- - 0
  - ▍
- - 0
  - ╲╱╲╱╳╳╳
- - 0
  - ║│╱
- - 0
  - ╲│║
- - 0
  - │║
- - 0
  - ║│
- - 0
  - ││
- - 0
  - │
- - 0
  - ││
- - 0
  - │║
- - 0
  - ┃
- - 0
  - ║│
- - 0
  - ┃│
- - 0
  - ╽
- - 0
  - │┃
- - 0
  - ░░▒▒▓▓██
- - 0
  - ┊
- - 0
  - ┆
- - 0
  - ╎
- - 0
  - ╏
- - 0
  - ┇
- - 0
  - ┋
- - 0
  - ▎
- - 0
  - ║└─╥─┘║
- - 0
  - │╚═╤═╝│
- - 0
  - │╘═╪═╛│
- - 0
  - │╙─╀─╜│
- - 0
  - ┃└─╂─┘┃
- - 0
  - ░░▒▒▓▓██
- - 0
  - ┊
- - 0
  - ┆
- - 0
  - ╎
- - 0
  - ╏
- - 0
  - ┇
- - 0
  - ┋
- - 0
  - ▏
- - 0
  - ╚══╩══╝
- - 0
  - └──┴──┘
- - 0
  - ╰──┴──╯
- - 0
  - ╰──┴──╯
- - 0
  - ┗━━┻━━┛
- - 0
  - ▗▄▖▛▀▜
- - 0
  - └╌╌┘
- - 0
  - ╎
- - 0
  - ┗╍╍┛
- - 0
  - ┋
- - 0
  - ▁▂▃▄▅▆▇█
- - 0
  - ▝▀▘▙▄▟
