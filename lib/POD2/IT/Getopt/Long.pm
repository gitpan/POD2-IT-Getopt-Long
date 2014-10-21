package POD2::IT::Getopt::Long;

use 5.004;
use strict;
use vars qw($VERSION $VERSION_ORIG);
$VERSION = '1.02';
$VERSION_ORIG = '1.35';

1;
#__END__

=pod

=head1 NAME

Getopt::Long - Elaborazione estesa delle opzioni a linea di commando

=head1 SYNOPSIS

  use Getopt::Long;
  my $data   = "file.dat";
  my $length = 24;
  my $verbose;
  $result = GetOptions ("length=i" => \$length,    # numero
                        "file=s"   => \$data,      # stringa
                        "verbose"  => \$verbose);  # flag

=head1 DESCRIPTION

Il modulo Getopt::Long implementa una funzione getopt estesa chiamata
GetOptions(). Questa funzione aderisce alla sintassi POSIX per le opzioni a
linea di comando, con le estensioni GNU. In generale, questo significa che le
ozioni hanno nomi lunghi al posto di singole lettere e sono precedute dal
doppio trattino "--". Il supporto per raggruppare le opzioni a linea di
comando, come era il caso con il pi� tradizionale approccio a singole lettere �
fornito ma non � abilitato per default.

=head1 Opzioni a linea di comando: una introduzione

I programmi prendono tradizionalmente i loro argomenti dalla linea di comando,
per esempio nomi di file o altre informazioni che il programma necessita di
conoscere. Oltre agli argomenti, i programmi prendono spesso anche I<opzioni> a
linea di comando. Le opzioni non sono necessarie al corretto funzionamento del
programma, da cui il nome 'opzione', ma sono usate  per modificarne il
comportamento di default. Per esempio, un programma potrebbe fare il suo lavoro
silenziosamente, ma un'opportuna opzione potrebbe fornire informazioni
descrittive su quello che sta facendo.

Le opzioni a lina di comando vengono specificate in diversi modi. Storicamente,
sono precedute da un singolo trattino C<->, e sono costituite da singole
lettere.

    -l -a -c

Solitamente, questi caratteri singoli possono venire raggruppati:

    -lac

Quando le opzioni posso avere dei valori, il valore � posto dopo l'opzione,
alcune volte con un spazio in mezzo, alcune volte no:

    -d 24 -d24

A causa della natura molto criptica di queste opzioni, � stato sviluppato un
altro stile che usa i nomi lunghi. Cos�, anzich� usare una opzione criptica
C<-l>, � possibile usare quella pi� descrittiva C<--lungo>.
Per distinguere un raggruppamento di opzioni a singolo carattere da una opzione
con nome lungo, vengono usati due trattini per precedere il nome dell'opzione.
Le prime implementazioni delle opzioni con nomi lunghi usavano il carattere
C<+>. Inoltre, i valori di una opzione con nome lungo possono essere specificati
sia con:

    --dimensione=24

che con:

    --dimensione 24

La forma C<+> � diventata obsoleta ed � fortemente deprecata.

=head1 Iniziare ad usare Getopt::Long

Getopt::Long � il successore Perl5 di C<newgetopt.pl>. Questo � stato il primo
modulo Perl che ha fornito il supporto per la gestione del nuovo stile delle
opzioni a linea di comando con nomi lunghi, da cui il nome Getopt::Long. Questo
modulo inoltre supporta le opzioni a singolo carattere e il loro
raggruppamento. Le opzioni a singolo carattere possono essere un qualsiasi
carattere alfabetico, un punto interrogativo e un trattino. Le opzioni a nomi
lunghi possono essere una serie di lettere, cifre e trattini. Anche se
attualmente questo non � fatto rispettare da Getopt::Long, multipli trattini
consecutivi non sono permessi ed il nome dell'opzione non deve terminare con un
trattino.

Per usare Getopt::Long da un programma Perl, dovete includere la seguente linea
nei vostri programmi Perl:

    use Getopt::Long;

Questo caricher� il nucleo del modulo Getopt::Long e preparer� il vostro
programma per usarlo. Gran parte dell'attuale codice di Getop::Long non viene
caricato fino a che realmente una delle sue funzioni non viene chiamata.

Nella configurazione di default, i nomi delle opzioni possono essere abbreviati
fino a che rimangono unici (all'unicit�), maiuscole/minuscole non sono
importanti e un singolo trattino � sufficiente, anche per i nomi di opzione
lunghi. Inoltre, le opzioni possono essere disposte fra gli argomenti
non-opzione. Si veda L<Configurare Getopt::Long> per maggiori informazioni su
come configurare Getopt::Long.

=head2 Opzioni semplici

Le opzioni pi� semplici sono quelle che non prendono valori. La loro semplice
presenza sulla linea di comando abilita l'opzione. Esempi diffusi sono:

    --all --verbose --quiet --debug

La gestione delle opzioni semplici � chiara:

    my $verbose = '';	# variabile di opzione con un valore di (falso)
    my $all = '';	# variabile di opzione con un valore di default (falso)
    GetOptions ('verbose' => \$verbose, 'all' => \$all);

La chiamata a GetOptions() analizza gli argomenti della linea di comando
presenti in C<@ARGV> a imposta la variabile di opzione a C<1> se l'opzione �
presente nella linea di comando. Altrimenti la variabile di opzione viene
ingorata. Settare l'opzione ad un valore vero � spesso chiamato I<abilitare>
l'opzione.

Il nome dell'opzione come specificato alla funzione GetOptions() � chiamato
I<specifica> dell'opzione. Pi� avanti vedremo che questa specifica pu�
contenere pi� cose che il solo nome dell'opzione. Il riferimento alla variabile
� chiamato I<destinazione> dell'opzione. 

GetOptions() restituir� un valore vero se la linea di comando sar� 
processasta con successo. Altrimenti scriver� un messaggio di errore sullo
STDERR e restituir� un valore falso.

=head2 Opzioni un po' meno semplici

Getopt::Long supporta due utili varianti delle opzioni semplici: le opzioni
I<negabili> e le opzioni I<incrementali>.

Una opzione negabile � specificata con un punto esclamativo C<!> dopo il nome
dell'opzione:

    my $verbose = '';	# variabile di opzione con un valore di default (falso)
    GetOptions ('verbose!' => \$verbose);

Ora, l'uso di C<--verbose> a linea di comando abiliter� C<$verbose>, come
previsto. Tuttavia � anche permesso l'uso di C<--noverbose> che disabiliter�
C<$verbose> impostandone il valore a C<0>. Usando un opportuno valore di
default, il programma pu� sapere quando C<$verbose> � falso per default oppure
� stato disabilitato  con C<--noverbose>.

Un'opzione incrementale � specificata con il carattere pi� C<+> dopo il nome 
dell'opzione: 

    my $verbose = '';	# variabile di opzione con un valore di default (falso)
    GetOptions ('verbose+' => \$verbose);

L'uso di C<--verbose> a linea di comando incrementer� il valore di C<$verbose>.
In questo modo il programma pu� tenere traccia di quante volte l'opzione �
stata scritta nella linea di comando. Per esempio, ogni occorrenza di
C<--verbose> potrebbe aumentare il livello di verbosit� del programma.

=head2 Mischiare le opzioni a linea di comando con gli altri argomenti 

Solitamente i programmi prendono le opzioni a linea di comando cos� come altri
argomenti, come ad esempio, nomi di file. � buona pratica specificare sempre
prima le opzioni e poi gli altri argomenti. Getopt::Long, tuttavia, permette di
mescolare opzioni e argomenti  ripulendo tutte le opzioni prima di passare il
resto degli argomenti al programma. Per interrompere Getopt::Long dal
processare ulteriori argomenti, inserite un doppio trattino C<--> sulla linea
di comando:

    --dimensione 24 -- --all

In questo esempio, C<--all> I<non> verr� considerata come un'opzione, ma sar�
passata al programma in C<@ARGV>.

=head2 Opzioni con valori

Per le opzioni che prevedono valori, deve essere specificato se il valore
dell'opzione � obbligatorio oppure no e quale tipo di valore l'opzione prevede.

Sono supportati tre tipi di valori: numeri interi, numeri a virgola mobile e
stringhe.

Se il valore dell'opzione � obbligatorio, Getopt::Long assegner� alla variabile
di opzione l'argomento della linea di comando che � immediatamente dopo
l'opzione. Se tuttavia il valore dell'opzione � facoltativo, l'assegnamento
sar� fatto soltanto se quel valore non assomiglia ad una opzione della linea di
comando.

    my $tag = '';	# variabile di opzione con un valore di default
    GetOptions ('tag=s' => \$tag);

Nella definizione dell'opzione, il nome dell'opzione � seguito da un segno di
uguale C<=> e dalla lettera C<s>. Il segno di uguale indica che questa opzione
richiede un valore. La lettera C<s> indica che questo valore � una stringa
arbitraria. Altri tipi possibili per il valore sono C<i> per numeri interi e
C<f> per numeri a virgola mobile. Usando i due punti C<:> anzich� il segno di
uguale, indichiamo che il valore dell'opzione � opzionale. In questo caso, se
non viene fornito alcun valore adatto, alle opzioni di stringa viene assegnata 
una stringa vuota C<''>, mentre le opzioni numeriche vengono impostate a C<0>.

=head2 Opzioni con valori multipli

A volte le opzioni prendono diversi valori. Per esempio, un programma
potrebbe usare pi� directory per cercare i file di libreria:

    --library lib/stdlib --library lib/extlib

Per fare ci�, specificate semplicemente un riferimento ad un array come
destinazione dell'opzione:

    GetOptions ("library=s" => \@libfiles);

Alternativamente, potete specificare che l'opzione pu� avere valori multipli
aggiungendo una "@" e passando come destinazione un riferimento ad uno scalare:

    GetOptions ("library=s@" => \$libfiles);

Usato con l'esempio qui sopra, C<@libfiles> (o C<@$libfiles>) conterrebbe le
stringhe C<"lib/srdlib"> e C<"lib/extlib">, in quest'ordine. � inoltre
possibile specificare numeri interi o a virgola mobile come soli valori
accettabili.

� spesso utile permettere liste di valori separate da virgole assieme alle
occorrenze multiple delle opzioni. Ci� � facilmente ottenibile usando gli
operatori Perl split() e join():

    GetOptions ("library=s" => \@libfiles);
    @libfiles = split(/,/,join(',',@libfiles));

Ovviamente � importante scegliere il giusto separatore di stringa per ogni
scopo.

Attenzione: quella che segue � una funzionalit� sperimentale.

Le opzione possono accettare valori multipli in una volta sola, ad esempio:

    --coordinate 52.2 16.4 --colorergb 255 255 149

Questo pu� essere ottenuto aggiungendo uno specificatore di ripetizione alla
definizione dell'opzione. Gli specificatori di ripetizione sono molto simili
agli specificatori di ripetizione C<{...}> che possono essere usati nelle
espressioni regolari. Per esempio, la suddetta linea di comando andrebbe
gestita nel modo seguente:

    GetOptions('coordinate=f{2}' => \@coor, 'colorergb=i{3}' => \@colore);

La destinazione per l'opzione deve essere un array o un riferimento ad un
array.

� inoltre possibile specificare il numero minimo e massimo di argomenti che un
opzione pu� prendere. C<foo=s{2,4}> indica un'opzione che prende almeno due
argomenti e non pi� di 4. C<foo=s{,}> indica uno o pi� valori; C<foo:s{,}>
indica zero o pi� valori.

=head2 Opzioni con valori hash

Se la destinazione dell'opzione � un riferimento ad un hash, l'opzione prender�
come valore stringhe nel formato I<chiave>C<=>I<valore>. Il valore sar�
memorizzato nell'hash con la chiave specificata.

    GetOptions ("define=s" => \%defines);

Alternativamente potete usare:

    GetOptions ("define=s%" => \$defines);

Ad esempio, con la seguente linea di comando:

    --define os=linux --define vendor=redhat

l'hash C<%defines> (o C<%$defines>) conterr� due chiavi, C<"os"> con valore
C<"linux> e C<"vendor"> con valore C<"redhat">. � inoltre possibile specificare
numeri interi o a virgola mobile come soli valori accettabili. Le chiavi sono
invece prese sempre per essere stringhe.

=head2 Subroutine definite dall'utente per gestire le opzioni

Un ultimo controllo su cosa dovrebbe essere fatto quando c'�
un'opzione sulla linea di comando, pu� essere realizzato specificando un
riferimento ad una subroutine (o ad una subroutine anonima) come destinazione
dell'opzione. Quando GetOptions() incontra l'opzione, chiamer� la subroutine
con due o tre argomenti. Il primo argomento � il nome dell'opzione. Se la
destinazione � uno scalare o un array, il secondo argomento � il valore
dell'opzione. Se la destinazione � un hash, il secondo argomento � la chiave
dell'hash e il terzo argomento � il valore dell'opzione. Spetta poi alla
subroutine memorizzare il valore da qualche parte, o fare qualunque altra cosa
opportunamente.

Una banale applicazione di questo meccanismo � quella di implementare opzioni
legate le une alle altre. Per esempio:

    my $verbose = '';	# variabile di opzione con un valore di default (falso)
    GetOptions ('verbose' => \$verbose,
	        'quiet'   => sub { $verbose = 0 });

In questo esempio C<--verbose> e C<--quiet> controllano la stessa variable
C<$verbose>, ma le assegnano valori opposti.

Nel caso la subroutine debba segnalare un errore, dovrebbe chiamare die() con
il messaggio di errore desiderato come suo argomento. GetOptions() intercetter�
la chiamata a die(), stamper� il messaggio di errore e registrer� che un
risultato di errore deve essere restituito per il completamento. 

Se il testo del messaggio di errore comincia con un punto esclamativo C<!>,
allora sar� interpretato in modo speciale da GetOptions(). Attualmente c'� un
solo comando speciale implementato: C<die("!FINISH")> indurr� GetOptions() a
interrompere l'elaborazione delle opzioni a linea di comando, come se
incontrasse un doppio trattino C<-->.

=head2 Opzioni con nomi multipli

Spesso � user-friendly fornire i nomi mnemonici alternativi per le opzioni. Ad
esempio C<altezza> potrebbe essere un nome alternativo a C<lunghezza>. I nomi
alternativi possono essere inclusi nella specifica dell'opzione, separati dal
carattere C<|>. Ad esempio:

    GetOptions ('lunghezza|altezza=f' => \$lunghezza);

Il primo nome � chiamato nome I<primario>, gli altri nomi sono detti
I<aliases>. Quando si usa un hash per memorizzare le opzioni. la chiave dovr�
sempre essere un nome primario.

Nomi alternativi multipli sono possibili.

=head2 Maiuscole/minuscole e abbreviazioni

Senza configurazioni aggiuntive, GetOptions() ignorer� maiuscole/minuscole dei
nomi delle opzioni e permetter� di abbreviare i nomi delle opzioni all'unicit� 
(cio� fino a che rimangono unici).

    GetOptions ('lunghezza|altezza=f' => \$lunghezza, 'altimetro' => \$altimetro);

Questo consente di specificare C<--l> e C<--L> per l'opzione 'lunghezza', ma
� necessario come minimo specificare C<--alti> e C<--alte> rispettivamente per le 
opzioni 'altimetro' e 'altezza'.

=head2 Sommario delle specifiche di opzione

Ogni specificatore di opzione consiste di due parti: il nome della specifica
l'argomento della specifica.

Il nome della specifica contiene il nome dell'opzione, opzionalmente seguito da
una lista dei nomi alternativi separati dal carattere C<|>.

    lunghezza	             il nome dell'opzione � "lunghezza"
    lunghezza|dimensione|l   il nome � "lunghezza", gli alias sono "dimensione" e "l"

L'argomento della specifica � opzionale. Se omesso, l'opzione � considerata
booleana, e il valore 1 sar� assegnato quando l'opzione � usata a linea di
comando.

L'argomento della specifica pu� essere

=over 4

=item !

L'opzione non prende argomenti e pu� essere negata precedendola con "no" o
"no-". Per esempio C<"foo!"> consentir� sia l'opzione C<--foo> (le sar� assegnato
il valore 1) che le opzioni C<--nofoo> e C<--no-foo> (le sar� assegnato il
valore 0). Se l'opzione ha degli pseudonimi, questo verr� applicato anche ad
essi.

L'uso della negazione su una opzione a singola lettera quando ci sono
raggruppamenti � ininfluente e generer� un avvertimento.

=item +

L'opzione non accetta argomenti e il suo valore verr� incrementato di 1 ad ogni
occorrenza nella linea di comando. Ad esempio C<"ancora+">, se usata con
C<--ancora --ancora --ancora>, incrementer� il suo valore tre volte restituendo
il valore 3 (supponendo che fosse inizialmente 0 o undef).

Lo specificatore C<+> viene ignorato se la destinazione dell'opzione non � uno
scalare.

=item = I<tipo> [ I<tipo_destinazione> ] [ I<ripetizione> ]

L'opzione richiede un argomento di un determinato tipo. I tipi supportati sono:

=over 4

=item s

Stringa. Un arbitraria sequenza di caratteri. Il valore del'argomento pu�
iniziare con C<-> o C<-->.

=item i

Intero. Sequenza di cifre opzionalmente preceduti dal segno meno o pi�.

=item o

Intero esteso, in stile Perl. Questo pu� iniziare con un segno meno o pi�
seguito da una sequenza di cifre, o una stringa ottale (uno zero, opzionalmente
seguito da '0', '1', .. '7'), o una stringa esadecimale (C<0x> seguito da '0'
.. '9', 'a' .. 'f', maiuscole/minuscole sono ininfluenti), o una stringa
binaria (C<0b> seguito da una serire di '0' e '1').

=item f

Numero reale. Per esempio C<3.14>, C<-6.23E24> e cos� via.

=back

Il I<tipo_destinazione> pu� essere C<@> o C<%> per specificare che la
destinazione dell'opzione � un lista o un hash. Questo � necessario solamente
quando la destinazione del valore dell'opzione non � altrimenti specificata e 
dovrebbe essere omessa quando non necessario.

I<ripetizione> specifica il numero di valori che questa opzione prende in ogni
occorrenza nella linea di comando. Ha il formato C<{> [ I<min> ] [ C<,> [
I<max> ] ] C<}>.

I<min> indica il numero minimo di argomenti. Il valore di default � 1 per le
opzioni con C<=> e 0 per le opzioni con C<:>. Si noti che I<min> sovrascrive la
semantica di C<=> / C<:>.

I<max> indica il numero massimo di argomenti. Deve essere almeno I<min>. Se
I<max> non  � specificato, I<ma la virgola no>, non c'� limite superiore al numero
di argomenti presi.

=item : I<tipo> [ I<tipo_destinazione> ]

Come C<=>, ma l'argomento � opzionale.
Se non specificato, al valore dell'opzione verr� assegnata una stringa vuota se
I<tipo> � una stringa e il valore zero se I<tipo> � un numero.

Si noti che, per le opzioni di tipo stringa, se l'argomento inizia con with C<->
o C<-->, questo verr� considerato come una nuova opzione.

=item : I<numero> [ I<tipo_destinazione> ]

Come C<:i>, ma se l'argomento non viene specificato, al valore dell'opzione
verr� assegnato il valore I<numero>.

=item : + [ I<tipo_destinazione> ]

Come C<:i>, ma se l'argomento non viene specificato, il valore corrente
dell'opzione verr� incrementato di 1.

=back

=head1 Uso avanzato

=head2 Interfaccia ad oggetti

Getopt::Long pu� essere anche usato con un'interfaccia ad oggetti:

    use Getopt::Long;
    $p = new Getopt::Long::Parser;
    $p->configure(...opzioni di configurazione...);
    if ($p->getoptions(...descrizioni delle opzioni...)) ...

Le opzioni di configurazione possono essere passare al costruttore:

    $p = new Getopt::Long::Parser
             config => [...opzioni di configurazione...];

=head2 Sicurezza dei thread

Getopt::Long � thread-safe quando si usa ithreads a partire dal Perl 5.8. Non �
thread-safe usando la vecchia implementazione (sperimentale ed ora obsoleta)
dei threads che � stata aggiunta in Perl 5.005.

=head2 Documentazione e testi di aiuto

Getopt::Long incoraggia l'uso di Pod::Usage per produrre i messaggi di aiuto.
Ad esempio:

    use Getopt::Long;
    use Pod::Usage;

    my $man = 0;
    my $help = 0;

    GetOptions('help|?' => \$help, man => \$man) or pod2usage(2);
    pod2usage(1) if $help;
    pod2usage(-exitstatus => 0, -verbose => 2) if $man;

    __END__

    =head1 NAME

    esempio - Uso di Getopt::Long e Pod::Usage

    =head1 SYNOPSIS

    esempio [opzioni] [file ...]

     Opzioni:
       -help            breve messagio di aiuto
       -man             documentazione completa

    =head1 OPTIONS

    =over 8

    =item B<-help>

    Stampa un breve messaggio di aiuto ed esce.

    =item B<-man>

    Stampa la pagina di manuale ed esce.

    =back

    =head1 DESCRIPTION

    B<Questo programma> legger� il (o i) file specificato in input e far�
    qualche cosa di utile con il suo contenuto.

    =cut

Si veda L<Pod::Usage> per maggiori informazioni.

=head2 Memorizzare i valori delle opzioni in un hash

A volte, ad esempio quando ci sono molte opzioni, avere una variabile separata
per ciascuna di loro pu� diventare pesante. GetOptions() supporta, come
meccanismo alternativo, la memorizzazione dei valori delle opzioni in un hash.

Per ottenere ci�, deve essere passato a GetOptions(), I<come primo argomento>,
un riferimento ad un hash. Per ogni opzione specificata nella linea di comando,
il valore dell'opzione sar� memorizzato nell'hash con il nome dell'opzione come
chiave. Le opzioni non usate a linea di comando non verranno messe nell'hash,
in altre parole, C<exists($h{nome_opzione})>C (o defined()) pu� essere utilizzata
per testare se un'opzione � stata usata. Lo svantaggio � che verranno generati
dei warning se il programma gira con C<use strict> e usa C<$h{nome_opzione}> senza
averla testata prima con exists() o defined().

    my %h = ();
    GetOptions (\%h, 'lunghezza=i');	# memorizzer� in $h{lunghezza}

Per le opzioni con valori multipli (liste o hash), � necessario utilizzare il
carattere C<@> o C<%> dopo il tipo:

    GetOptions (\%h, 'colori=s@');	# memorizzer� in @{$h{colori}}

Per rendere pi� complicate le cose, l'hash pu� contenere dei riferimenti alle
attuali destinazioni delle opzioni, ad esempio:

    my $lunghezza = 0;
    my %h = ('lunghezza' => \$lunghezza);
    GetOptions (\%h, 'lunghezza=i');	# memorizzer� in $lunghezza

Questo esempio � completamente equivalente a:

    my $lunghezza = 0;
    GetOptions ('lunghezza=i' => \$lunghezza);	# memorizzer� in $lunghezza

Ogni combinazione � possibile. Per esempio, le opzioni usate pi� frequentemente
potrebbero essere memorizzate nelle variabili mentre tutte le altre
opzioni in un hash:

    my $verbose = 0;			# usata frequentemente
    my $debug = 0;			# usata frequentemente
    my %h = ('verbose' => \$verbose, 'debug' => \$debug);
    GetOptions (\%h, 'verbose', 'debug', 'filtro', 'dimensione=i');
    if ( $verbose ) { ... }
    if ( exists $h{filtro} ) { ... l'opzione 'filtro' � stata specificata ... }

=head2 Raggruppamenti

Con il raggruppamento � possibile specificare diverse opzioni a singolo carattere
in una sola volta. Ad esempio, se C<a>, C<v> e C<x> sono opzioni valide, con:

    -vax

si imposterebbero tutte e tre.

Getopt::Long supporta due livelli di raggruppamento. Per abilitare il
raggruppamento, � necessario esguire una chiamata a Getopt::Long::Configure. 

Il primo livello di raggruppamento pu� essere abilitato con:

    Getopt::Long::Configure ("bundling");

Configurato in questo modo, le opzioni a singolo carattere possono essere
raggruppate ma le opzioni con nome lungo B<devono> sempre iniziare col doppio
trattino C<--> per evitare ambiguit�. Ad esempio, se C<a>, C<v> e C<x> sono
opzioni valide,

    -vax

imposterebbe C<a>, C<v> e C<x>, ma

    --vax

imposterebbe C<vax>.

Il secondo livello di raggruppamento alza questa limitazione e pu� essere
abilitato con:

	 Getopt::Long::Configure ("bundling_override");

Ora C<-vax> imposterebbe l'opzione C<vax>.

Quando un qualsiasi livello di raggruppamento � stato abilitato, i valori delle
opzioni possono venire inseriti nel raggruppamento. Per esempio:

    -h24w80

� equivalente a:

    -h 24 -w 80

Una volta configurato il raggruppamento, le opzioni a singolo carattere sono
matchate considerando maiuscole e minuscole mentre le opzioni con nomi lunghi
sono mathcate ignorando maiuscole e minuscole. Per avere anche le opzioni a
singolo carattere matchate ignorando maiuscole e minuscole, usate:

    Getopt::Long::Configure ("bundling", "ignorecase_always");

Va da s� che il raggruppamento pu� generare abbastanza confusione.

=head2 Il trattino solitario

Normalmente, un trattino singolo C<-> a linea di comando non � considerato
un'opzione. L'elaborazione delle opzioni terminer� (a meno che venga
specificato "permute") ed il trattino sar� lasciato in C<@ARGV>. 

� possibile avere un trattamento speciale per il singolo trattino. Questo pu�
essere ottenuto aggiungendo una specifica di opzione con un nome vuoto, per
esempio: 

    GetOptions ('' => \$stdio);
	 
Un trattino singolo a linea di comando ora sar� un'opzione valida e, se usato,
verr� impostata la variabile C<$stdio>.

=head2 Callback per gli argomenti

L'opzione particolare C<< <> >> pu� essere usata per indicare una subroutine
per la gestione di argomenti che non siano un'opzione. Quando GetOptions()
incontra un argomento che non assomiglia ad un'opzione, immediatamente chiamer�
questa subroutine e le passer� un parametro: il nome dell'argomento.

Per esempio:

    my $larghezza = 80;
    sub processa { ... }
    GetOptions ('larghezza=i' => \$larghezza, '<>' => \&processa);

Con la seguente linea di comando:

    arg1 --larghezza=72 arg2 --larghezza=60 arg3

verr� chiamato C<processa("arg1")> quando C<$larghezza> ha il valore C<80>,
C<processa("arg2")> quando C<$larghezza> � C<72>, e C<processa("arg3")> quando
C<$larghezza> � C<60>.

Questa funzionalit� richiede l'opzione di configurazione B<permute>, si veda la
sezione  L<Configurare Getopt::Long>.

=head1 Configurare Getopt::Long

Getopt::Long pu� essere configurato chiamando la funzione
Getopt::Long::Configure(). Questa subroutine ha come argomento una lista di
stringhe quotate, ognuna relativa all'opzione di configurazione che si vuole
abilitare, ad esempio C<ignore_case>, o  disabilitare, ad esempio
C<no_ignore_case>. Maiuscole e minuscole vengono ignorate. E' possibile
chiamare Configure() pi� volte.

Alternativamente, dalla versione 2.24, le opzioni di configurazione possono
essere specificate con il comando C<use>:

    use Getopt::Long qw(:config no_ignore_case bundling);

Sono disponibili le seguenti opzioni:

=over 12

=item default

Questa opzione reimposta tutte le opzioni di configurazione ai valori di
default.

=item posix_default

Questa opzione ripristina il valore di default di tutte le opzioni di
configurazione come se la variabile di ambiente POSIXLY_CORRECT fosse stata
settata.

=item auto_abbrev

Permette ai nomi di opzione di essere abbreviati all'unicit� (cio� fino a che 
rimangono unici). Per default questa opzione � abilitata a meno che la variabile
di ambiente POSIXLY_CORRECT non sia stata settata, nel qualo caso C<auto_abbrev> 
� disabilitata.

=item getopt_compat

Consente l'utilizzo di C<+> per specificare le opzioni.
Per default questa opzione � abilitata a meno che la variabile di ambiente
POSIXLY_CORRECT non sia stata settata, nel qualo caso C<getopt_compat> �
disabilitata.

=item gnu_compat

C<gnu_compat> controlla quando la forma C<--opt=> � consentita e cosa dovrebbe
fare. Senza C<gnu_compat>, C<--opt=> produce un errore. Con C<gnu_compat>,
C<--opt=> restituir� l'ozione C<opt> e un valore vuoto. Questo � il
comportamento della funzione GNU getopt_long().

=item gnu_getopt

Questo � un modo veloce per abilitare C<gnu_compat> C<bundling> C<permute>
C<no_getopt_compat>. Con C<gnu_getopt>, la gestione della linea di comando
dovrebbe essere pienamente compatibile con la funzione GNU getopt_long().

=item require_order

Non consente di mescolare gli argomenti della linea di comando con le opzioni.
Per default questa opzione � disabilitata a meno che la variabile di ambiente
POSIXLY_CORRECT non sia stata settata, nel qualo caso C<require_order> �
abilitata.

Si veda anche C<permute>, che � l'opposto di C<require_order>.

=item permute

Consente di mescolare gli argomenti della linea di comando con le opzioni.
Per default questa opzione � abilitata a meno che la variabile di ambiente
POSIXLY_CORRECT non sia stata settata, nel qualo caso C<permute> �
disabilitata.
Si noti che C<permute> � l'opposto di C<require_order>.

Se C<permute> � abilitata, significa che 

    --pippo arg1 --pluto arg2 arg3

� equivalente a

    --pippo --pluto arg1 arg2 arg3

Se � stata specificata una routine di callback per gli argomenti, C<@ARGV> sar�
sempre vuoto dopo una chiamata (senza errori) a GetOptions() poich� tutte le
opzioni sono state processate. L'unica eccezione � quando si usa C<-->:

    --pippo arg1 --pluto arg2 -- arg3

La routine di callback verr� chiamata per arg1 e arg2 quindi GetOptions()
terminer� l'elaborazione lasciando "arg3" in C<@ARGV>.

Se C<require_order> � abilitata, l'elaborazione delle opzioni termina quando
viene incontrata la prima non-opzione:

    --pippo arg1 --pluto arg2 arg3

� come:

    --pippo -- arg1 --pluto arg2 arg3

Inoltre se C<pass_through> � abilitata, l'elaborazione delle opzioni terminer�
alla prima opzione che non venga riconosciuta, o che non sia un'opzione.

=item bundling (default: disabilitata)

Abilitando questa opzione, si permetteranno i raggruppamenti di opzioni a
singolo carattere. Per distinguere i raggruppamenti dalle opzioni con nomi
lunghi, queste devono essere precedute da  C<--> e i raggruppamenti da C<->.

Si noti che, se avete le opzioni C<t>, C<u> and C<tutti>, e C<auto_abbrev> �
abilitato, i possibili argomenti e opzioni sono:

    argomenti                    opzioni settate
    --------------------------------------------
    -t, --t                      t
    -u, --u                      u
    -tu, -ut, -tut, -tuu,...     t, u
    --tu, --tutti                tutti

La cosa sorprendente � che C<--t> imposta l'opzione C<t> (a causa dell'auto
completamento) non C<tutti>.

Nota: Disabilitando C<bundling> si disabilita anche C<bundling_override>.

=item bundling_override (default: disabilitata)

Se C<bundling_override> � abilitata, il raggruppamento � consentito come con
C<bundling> ma ora le opzioni con nomi lunghi hanno la precedenza sui
raggruppamenti.

Nota: Disabilitando C<bundling_override> si disabilita anche C<bundling>.

B<Nota:> L'utilizzo dei raggruppamenti pu� facilmente portare a risultati
inaspettati, soprattutto quando vengono mischiati con le opzioni con nomi
lunghi. Caveat emptor.

=item ignore_case (default: abilitata)

Se abilitata, maiuscole e minuscole vengono ignorate nel match delle opzioni
con nomi lunghi. Tuttavia, nei raggruppamenti, le opzioni a singolo carattere 
verranno trattate case-sensitive.

Con C<ignore_case>, le specifiche di opzione per le opzioni che differiscono 
soltanto per maiuscole/minuscole, ad esempio C<pippo> e C<Pippo>, saranno 
marcate come duplicate.

Nota: disabilitando l'opzione C<ignore_case> si disabilita anche l'opzione 
C<ignore_case_always>.

=item ignore_case_always (default: disabilitata)

Quando si usa il raggruppamento, le opzioni a singolo carattere non verranno 
trattate case-sensitive.

Nota: disabilitando l'opzione C<ignore_case_always> si disabilita anche 
l'opzione C<ignore_case>.

=item auto_version (default: disabilitata)

Fornisce automaticamente il supporto per l'opzione di B<--version> nel caso in
cui l'applicazione non specificasse un handler per questa opzione.

Getopt::Long fornir� un messaggio standard di versione che include il nome del
programma, la versione (se $main::VERSION � definita) e le versioni di 
Getopt::Long e Perl. Il messaggio sar� stampato nello standard output e
l'esecuzione del programma terminer�. 

C<auto_version> sar� abilitata se il programma specificasse esplicitamente un
numero di versione superiore a 2.32 nei comandi C<use> o C<require>.

=item auto_help (default: disabilitata)

Fornisce automaticamente il supporto per le opzioni B<--help> e B<-?> nel caso in
cui l'applicazione non specificasse un handler per queste opzioni.

Getopt::Long fornir� un messaggio di aiuto utilizzando il modulo L<Pod::Usage>. 
Il messaggio, ricavato dalla sezione POD SYNOPSIS, sar� scritto nello standard 
output e l'esecuzione del programma terminer�. 

C<auto_help> sar� abilitata se il programma specificasse esplicitamente un
numero di versione superiore a 2.32 nei comandi C<use> o C<require>.

=item pass_through (default: disabilitata)

Le opzioni sconosciute, ambigue o che hanno un valore non valido sono passate
in C<@ARGV> invece che essere marcate come errori. Questo consente di scrivere 
programmi che processano soltanto parte degli argomenti a linea di comando 
forniti dall'utente e passano le restanti opzioni ad un altro programma. 

Se C<require_order> � abilitata, l'elaborazione delle opzioni terminer� appena 
sar� incontrata la prima opzione non riconosciuta, o un valore che non sia 
un'opzione. Tuttavia, l'abilitazione di C<permute> potrebbe generare confusione 
nel risultato dell'elaborazione.

Si noti che l'opzione di terminazione (per default C<-->), se presente, sar�
anch'essa passata in C<@ARGV>.

=item prefix

Stringa che inizia le opzioni. Se una stringa costante non � sufficiente, 
si veda C<prefix_pattern>.

=item prefix_pattern

Pattern Perl che identifica le stringhe che introducono le opzioni. Il valore di
default � C<--|-|\+> a meno che la variabile di ambiente POSIXLY_CORRECT sia 
stata settata, nel qual caso � C<--|->.

=item long_prefix_pattern

Pattern Perl che permette di risolvere le ambiguit� dei prefissi lunghi e corti.
Il valore di default � C<-->.

Tipicamente avete bisogno di settare questa opzione soltanto se state usando 
prefissi non standard e desiderate avere, per qualcuno di questi o per tutti,
la stessa semantica di '--' in circostanze normali.

Ad esempio, impostando prefix_pattern a C<--|-|\+|\/> e long_prefix_pattern a 
C<--|\/> si aggiungerebbe lo stile Win32 per la gestione degli argomenti a linea
di comando.

=item debug (default: disabilitata)

Abilita l'output di informazioni di debug.

=back

=head1 Metodi esportabili

=over

=item VersionMessage

Questa subroutine fornisce un messaggio di versione standard. Il suo argomento
pu� essere:

=over 4

=item *

Una stringa contenente il testo del messaggio da stampare I<prima> di stampare
il messaggio standard.

=item *

Un valore numerico corrispondente al valore di uscita desiderato.

=item *

Un riferimento ad un hash.

=back

Se viene passato pi� di un argomento, allora l'intera lista degli argomenti 
� considerata un hash. Se viene passato un hash (sia come riferimento che come 
lista), questo dovrebbe contenere uno o pi� elementi con le seguenti chiavi:

=over 4

=item C<-message>

=item C<-msg>

Il testo del messaggio da stampare immediatamente prima di stampare il messaggio
di utilizzo del programma.

=item C<-exitval>

Valore di uscita desiderato da passare alla funzione B<exit()>.
Questo valore deve essere un numero intero, oppure la stringa "NOEXIT" per 
indicare che il controllo dovrebbe essere semplicemente restituito senza 
terminare il processo d'invocazione.

=item C<-output>

Riferimento ad un filehandle o path del file sul quale il messaggio di 
utilizzo dovrebbe essere scritto. Il valore di default � C<\*STDERR> a meno che 
il valore di uscita sia minore di 2 (nel qual caso il valore di default � 
C<\*STDOUT>).

=back

Non potete legare direttamente questa funzione ad un'opzione, ad esempio:

    use Getopt::Long qw(VersionMessage);
    GetOptions("version" => \&VersionMessage);

bens� va usato:

    use Getopt::Long qw(VersionMessage);
    GetOptions("version" => sub { VersionMessage(-msg => 'Mio messaggio') });

=item HelpMessage

Questa subroutine produce un messaggio standard di aiuto, ricavato dalla sezione
POD SYNOPSIS del programma usando L<Pod::Usage>.
La funzione accetta gli stessi argomenti di VersionMessage(). In particolare, 
non potete legare questa funzione direttamente ad un'opzione, per esempio:

    GetOptions("help" => \&HelpMessage);

Scrivere invece:

    GetOptions("help" => sub { HelpMessage() });

=back

=head1 Valori di ritorno ed errori

Gli errori di configurazione e gli errori nelle definizioni delle opzioni sono 
segnalati usando die() e causano la terminazione del programma chiamante a meno
che la chiamata a Getopt::Long::GetOptions() sia stata inclusa in C<eval { ... }>, 
o die() sia stato intercettato usando C<$SIG{__DIE__}>.

GetOptions restituisce un valore vero in caso di successo. 
Restituisce un valore falso quando la funzione ha rilevato uno o pi� errori 
durante l'elaborazione delle opzioni. Questi errori sono segnalati usando warn()
e possono essere intercettati usando C<$SIG{__WARN__}>.

=head1 Compatibilit� con le versioni precedenti

Lo sviluppo iniziale di C<newgetopt.pl> � iniziato nel 1990, con la versione 4 
di Perl. Di conseguenza, il suo sviluppo e lo sviluppo di Getopt::Long sono 
passati attraverso parecchie fasi. Poich� la compatibilit� all'indietro � stata 
sempre estremamente importante, la versione corrente di Getopt::Long ancora 
supporta molti costrutti che al giorno d'oggi non sono pi� necessari o al 
contrario sono indesiderabili.
Questa sezione descrive brevemente alcune di queste 'caratteristiche'.

=head2 Destinazioni di default

Quando nessuna destinazione � specificata per un'opzione, GetOptions memorizzer�
il valore risultante in una variabile globale chiamata C<opt_>I<XXX>, in cui 
I<XXX> � il nome primario di questa opzione. Quando un progamma viene eseguito 
con C<use strict> (pratica consigliata), queste variabili devono essere 
dichiarate con our() o C<use vars>.

    our $opt_lunghezza = 0;
    GetOptions ('lunghezza=i');	# memorizzer� in $opt_lunghezza

Per rendere una variabile utilizzabile dal Perl, i caratteri che non fanno parte
della sintassi delle variabili, vengono sostituiti con il carattere undescore
(C<_>). Per esempio, C<--fpp-struct-return> imposter� la variabile
C<$opt_fpp_struct_return>. Si noti che questa variabile sta nel namespace del 
programma chiamante, non necessariamente C<main>. Per esempio la seguente 
istruzione:

    GetOptions ("size=i", "sizes=i@");

con la linea di comando "-size 10 -sizes 24 -sizes 48", � equivalente agli 
assegnamenti:

    $opt_size = 10;
    @opt_sizes = (24, 48);

=head2 Caratteri di inizio opzioni alternativi

Una stringa di caratteri alternativi per introdurre le opzioni pu� 
essere passata come primo argomento (o come argomento subito dopo un riferimento
ad un hash quando questo � il primo argomento).

    my $len = 0;
    GetOptions ('/', 'length=i' => $len);

Ora la linea di comando pu� essere simile alla seguente:

    /length 24 -- arg

Si noti che per terminare l'elaborazione delle opzioni � ancora necessario un 
doppio trattino C<-->.

GetOptions() non interpreter� C<< "<>" >> come caratteri di inizio opzione
se l'argomento successivo � un riferimento.
Per forzare C<< "<" >> e C<< ">" >> come caratteri di inizio opzione, usare
C<< "><" >>. Confusi? Bene, ad ogni modo B<l'utilizzo di caratteri di inizio 
opzione � vivamente sconsigliato>.

=head2 Variabili di configurazione

Le precedenti versioni di Getopt::Long usavano le variabili per la configurazione.
Anche se il settaggio di queste variabili ancora funziona, � vivamente 
consigliato di usare la funzione C<Configure> che � stata introdotta nella 
versione 2.17. Inoltre, � molto pi� facile.

=head1 Risoluzione dei problemi

=head2 GetOption non restituisce un valore falso quando un'opzione non viene fornita

Ecco perch� esse sono chiamate 'opzioni'.

=head2 GetOptions non splitta correttamente la linea di comando

La linea di comando non viene splittata da GetOptions, ma dall'interprete della
linea di comando (CLI). In Unix, questo � rappresentato dalla shell. In
Windows, �  COMMAND.COM o CMD.EXE. Altri sistemi operativi hanno altri CLI.

E' importante sapere che questi interpreti della linea di comando possono
comportarsi in maniera differente quando la linea di comando contiene caratteri
speciali, in particolare virgolette o backslash. Ad esempio, con le shell Unix,
potete usare virgolette semplici (C<'>)  o doppie (C<">) per raggruppare
insieme le parole. Le seguenti espressioni in Unix sono equivalenti:

    "due parole"
    'due parole'
    due\ parole

In caso di dubbio, mettete la seguente istruzione all'inizio del vostro
programma Perl:

    print STDERR (join("|",@ARGV),"\n");

per verificare come la vostra CLI passi gli argomenti al programma.

=head2 "Undefined subroutine &main::GetOptions called"

State utilizzando Windows e avete scritto:

    use GetOpt::Long;

(notate la 'O' maiuscola)?

=head2 Come posso mettere l'opzione "-?" in Getopt::Long?

Potete ottenere ci� solamente utilizzando un alias e Getopy::Long a partire
almeno dalla versione 2.13

    use Getopt::Long;
    GetOptions ("help|?");    # -help e -? imposteranno entrambi $opt_help

=head1 AUTORE

Johan Vromans <jvromans@squirrel.nl>

=head1 COPYRIGHT E DISCLAIMER

Questo programma � Copyright 1990,2005 di Johan Vromans.

Questo programma � software libero; esso pu� essere distribuito secondo gli
stessi termini della Licenza Artistica Perl o della GNU General Public License
come pubblicata dalla Free Software Foundation sia nella versione 2 della
License, che (a vostra scelta) nelle versioni successive.

Questo programma viene distribuito nella speranza che sia utile, ma SENZA
ALCUNA GARANZIA; senza la garanzia implicita di COMMERCIABILIT� o di
IDONEIT� PER UNO SCOPO PRECISO. Si veda la GNU General Public License per
maggiori informazioni.

Se non disponete di una copia della GNU General Public License scrivete alla
Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=head1 TRADUZIONE

=head2 Versione

La versione originale su cui si basa questa traduzione E<egrave> ottenibile 
con:

   perl -MPOD2::IT::Getopt::Long -e 'print $POD2::IT::Getopt::Long::VERSION_ORIG'

Per maggiori informazioni sul progetto di traduzione
in italiano si veda http://pod2it.sourceforge.net/ .

=head2 Traduttore

Traduzione a cura di Enrico Sorcinelli. 

=head2 Revisore

Revisione non ancora effettuata (ogni revisore � ben accetto! :-)).

=cut
