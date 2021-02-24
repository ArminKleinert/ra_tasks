#!/usr/bin/env ruby
# frozen_string_literal: true

TABLES = [
  #__BKS__
  {
  "Was sind die Schichten im OSI Modell?" => "7. Application\n6. Darstellung\n5. Session\n4. Transport\n3. Network\n2. Datalink\n1. Bitübertragung",
  "Was sind die Schichten im TCP/IP Modell?" => "4. Application\n3. Transport\n2. Internet\n1. Network",
  "Was sind die Schichten im OSI Modell? " => "7. Application\n6. Darstellung\n5. Session\n4. Transport\n3. Network\n2. Datalink\n1. Bitübertragung",
  "Welche Protokolle liegen im 7.-5. Layer des OSI Modells / Layer 4. im TCP/IP?" => "Layer 7: HTTP(S), FTTP, Telnet, NTP, DHCP, PING\nLayer 6: SSL\nLayer 5: Socket, Netbios",
  "Welche Protokolle liegen im 4. Layer des OSI Modells / Layer 3. im TCP/IP?" => "TCP, UDP",
  "Welche Protokolle liegen im 3. Layer des OSI Modells / Layer 2. im TCP/IP?" => "IP, Arp, ICMP, IGMP",
  "Welche Protokolle liegen im 2-1. Layer des OSI Modells / Layer 1. im TCP/IP?" => "Ethernet",
  "Was gehört zum 7. Layer des OSI Modells?" => "Anwendungen, I/O",
  "Was \"tut\" der 6. Layer des OSI Modells?" => "Umwandlung von systemabhängigen Daten in unabhängiges Format",
  "Was \"tut\" der 5. Layer des OSI Modells?" => "Steuerung von Verbindung und Datenaustausch",
  "Was \"tut\" der 4. Layer des OSI Modells?" => "Zuordnung von Paketen zu Anwendungen",
  "Was \"tut\" der 3. Layer des OSI Modells?" => "Vermittlung zum nächsten Knoten",
  "Was \"tut\" der 2. Layer des OSI Modells?" => "Segmentierung und Prüfsummen.",
  "Was \"tut\" der 1. Layer des OSI Modells?" => "Übertragung.",
  "Welche Hardware kann den Layern 1-3 im OSI Modell zugeordnet werden?" => "Layer 7-5: DNS-Server, User Agent (für E-Mails), Terminal, Message Transfer Agents\nLayer 3: Router\nLayer 2: Switch\nLayer 1: Repeater",
  "Was ist die Abstraktion des Prozessors und was sind die Vorteile?" => "Processes.\n- Theoretisch mehrere Prozesse pro Prozessor\n- Priorisierung durch OS möglich",
  "Was ist die Abstraktion des Arbeitsspeichers und was sind die Vorteile?" => "Virtual Memory\n- Vermeidung internet Fragmentierung\n- Prozesse können Speicher als großen Block behandeln\n- Abgeschotteter Speicher pro Prozessor\n- Prozesse können tun, als sei ihr Speicher unbegrenzt",
  "Was ist die Abstraktion des persistenten Speichers / von Festplatten und was sind die Vorteile?" => "Files\n- Ansicht\n- Dateien können segmentiert werden, sich aber als großen Block sehen",
  "Was ist die Abstraktion des Netzwerk Interfaces und was sind die Vorteile?" => "Ports\n- Abstraktion für Kommunikation zwischen Prozessoren und Geräten",
  "Wie nennt man den Wechsel zwischen den Schutzringen und was sind 2 übliche Beispiele dafür?" => "Context Switch\n- Syscalls: Anfrage an Kernel\n- Segfaults / Memory Faults: OS bricht Prozess ab und gibt Ressourcen frei.",
  "Welche FUnktionen übernimmt ein Mikrokernel?" => "- Speicher-, Prozess- und Rechteverwaltung\n- Synchronisation und Kommunikation von Prozessen",
  "Warum sind Syscalls bei Mikrokerneln langsamer als bei monolithischen Kerneln?" => "Context Switches sind teuer. Funktionalitäten können in User-Prozessen sein. Also springt der Call in den Kernel-Mode, dann in den Usermode, wieder in den Kernelmode, dann zurück in den Usermode.\nUsermode: Syscall           Ausführung        Fortsetzung\nKernelmode:       Umleitung            Return",
  "Ein Vorteil von Mikrokerneln?" => "Bspw. wenn ein Prozess in Mikrokerneln kritisch fehlschlägt, stürzt der Prozess nur im Usermode ab, nicht im Kernelmode. Damit crasht nicht das gesamte System.",
  "Ist bei Interrupts immer ein voller Context Switch nötig? Wenn nein, wann und warum nicht?" => "Nein. Bei Software-Interrupts kann genau geplant werden, welche Register gesichert werden müssen.",
  "Was ist Polling und wo/warum wird es genutzt?" => "Eine regelmäßige Anfrage, ob ein Event eingetreten ist.\n- Genutzt bei USB-Ports und spezialisierten Systemen\n- Kein Check für Priorität, keine Sicherung der Register, weniger Overhead",
  "Was ist der große Nachteil bei Polling?" => "- Wartet auf ein Event\n- Kann nebenbei nichts anderes tun\n- Dadurch höherer Stromverbrauch",
  "Ablauf eines Interrupts in Hard- und Software?" => "Hardware:\n1. I/O sended Signal an CPU\n2. Laufende Instruktion wird zuende bearbeitet\n3. CPU nimmt den Interrupt an und sendet ein Signal an das Gerät\n4. PSW und PC werden auf dem Stack gespeichert\n5. Register werden auf dem Stack gespeichert\n6. (Fortsetzung in Software)\nSoftware:\n1. Wichtige Register werden gespeichert\n2. ISR wird aufgerufen\n3. Register werden wiederhergestellt\n4. PSW und PC werden wieder hergestellt",
  "Warum ist es einfacher, im TCP/IP Modell auf Schicht 4 ein neues Protokoll einzuführen als auf Schicht 3?" => "Schicht 4 ist hauptsächlich software-basiert, Schicht 3 hardware-basiert.",
  "Was sind die Unterschiede zwischen MAC-Adresse und IP-Adressen?" => "MAC-Adresse: Eindeutige ID und physikalische Adresse des Geräts im Rechnernetz.\nIP-Adresse:  Hierarchisch strukturierte, logische Adressen des Netzwerks.",
  "Was sind interne und externe Fragmentierung. Wie hilft Paging?" => "Interne Fragmentierung:\n- Block von Speicher nur als ganzes anwendbar (feste Partitionierung)\n- Wenn ein Bereich nicht mehr gebraucht wird, kann er nicht für andere Prozesse verwendet werden.\nExterne Fragmentierung:\n- Bei dynatischer Partitionierung\n- Wenn Blöcke allokiert und freigegeben werden, können Lücken entstehen, die zusammen groß genug für einen neuen Block sind, aber einzeln nicht.\nPaging hilft weil...\nDie MMU kann Adressen übersetzen und in kleinere Teile splitten (im persisten Speicher \"Frames\", in Prozessen \"Pages\").",
  "Wann tritt Thrashing auf, was tut es?" => "- Tritt auf, wenn der RAM voll ausgelastet ist.\n- Daten können woanders abgelagert werden.\n- Ladezeiten werden länger.\nEs gibt Heap Threashing, Cache Thrashing und Process Thrashing.",
  "Was ist die TLB, was unterscheidet sie von der Page Table?" => "- Genutzt von der MMU\n- Speichert die zuletzt genutzten Page Numbers damit Seiten schneller gefunden werden können.",
   "" => ""
  # Fortsetzung folgt
},
  #__RA__
{
 "Was ist ein general-purpose Computer (nach Von-Neumann-Rechnermodell)?" => "- Nicht als Lösung für ein spezifisches Problem\n- Lösung für viele allgemeine Probleme\n- Welches Problem gelöst wird ist vom Programm abhängig",
 "Programme im von-Neumann-Modell sind nur Daten. Was bedeutet das?" => "- Das von-Neumann-Modell kennt nur einen Speicher\n- Befehle und Daten befinden sich im selben Speicher\n- Was als Daten und was als Befehle erkannt wird, hängt von der Interpretation ab",
 "Was sind die 4 Bestandteilee des von-Neumann-Modells und was tun sie?" => "Prozessor (CPU), Hauptspeicher, IO, BUS\nCPU: Zentrale Steuerung der Vorgänge und Ausführung von Befehlen\nIO: Zugang zum System durch Geräte wie Tastatur und Maus\nHauptspeicher: Speicher für Daten\nBUS: Übertragung sämtlicher Daten zu allen Bereichen des Geräts",
 "Was tun der Daten- und Befehlsprozessor der CPU?" => "- Befehlsprozessor (Steuereinheit) interpretiert CPU-Befehle und formt daraus Signale.\n- Datenprozessor (Recheneinheit) führt Befehle mittels IO aus.\nAlso: Befehlsprozessor gibt Befehl, Datenprozessor führt Befehl aus.",
 "Warum sind Daten und Adressbus getrennt?" => "Parallele Ausführung ist schneller.",
 "Was ist SISD? Was sind die anderen Varianten nach Flynn?" => "SISD (Single Instruction, Single Data): Zur selben Zeit nur ein Befehl auf einen Wert.\nSIMD (Single Instruction, Multiple Data): Zur selben Zeit eine Instruction, die auf verschiedene Daten zugreifen kann (Cool für Vektoren)\nMISD (Multiple Instruction, Single Data): Mehrere Instruktionen auf einen Wert\nMIMD (Multiple Instruction, Multiple Data): Wie MISD aber auf mehrere Daten gleichzeitig.",
 "Universelle Programmierbarkeit nach von-Neumann?" => "Programmiersprachen Turing-Vollständig",
 "Maschienencode, Assemblersprache, Ein-Adress-Befehle, Mehr-Adress-Befehle?" => "- Maschinencode: Abfolge von Bytes, direkt von CPU ausführbar\n- Assemblersprache: Menschenlesbar und direkt in Maschinencode übersetzbar\n- Ein-Adress-Befehl: Eine Anweisung auf einen Wert (wie JMP)\n- Mehr-Adress-Befehl: Eine Anweisung mit mehreren Operanten (MOV, ADD, JLE, ...)",
 "Zwei-Phasen-Konzept der Befehlsverarbeitung nach von-Neumann?" => "1. Phase:\n- Liest Speicherzelle, auf die der Program-Counter (PC) zeigt, interpretiert als Befehl\n2. Phase:\n- Ausführung inklusive IF, ID, OF, EX und WB\n",
 "von-Neumann Flaschenhals?" => "- Daten laufen nur sequenziell über einen einzelnen Bus\n- CPU schneller als der Hauptspeicher => Leistung der CPU nicht voll genutzt.\n- Umgangen durch getrennte Caches für Befehle und Daten",
 "Was sind Lazy-, Normal- und Eager Allocation?" => "Lazy: Speicher so spät wir möglich allokieren und nur wenn notwendig. (Startup scchneller, Speicherverbrauch niedriger und inkonsistent, Laufzeit schlechter)\nNormal: Memory beim Betreten eines bestimmten Punkts im Prozess allokieren.\nEager: Speicher beim Startup allokieren (Startup dauert länger, Speicherverbrauch ist höher aber konstant, dafür ist der Ablauf danach schneller)",
 "Scheduling: Was sind FCFS, SPN, RoundRobin, SRT und HRRN?" => "FCFS: Non-preemptive*; In-Order\nSPN:  Non-Preemptive; Kürzeste Prozesse zuerst;\nRoundRobin: Prozess wird für eine Zeit bearbeitet, dann unterbrochen und im nächsten Zyklus fortgesetzt; Preemptive\nSRT:  Zyklus-Bearbeitung; Prozesse pro Zyklus nach kürzester Zeit priorisiert; Bei Abschluss kann im selben Zyklus der nächste Prozess starten; Preemptive\nHRRN: Prozesse nach RespondRatio priorisiert ((Wartezeit+Gesamtzeit)/Gesamtzeit); Non-Preemptive\n\nPreemptive: Prozesse können unterbrochen werden\nNon-Preemptive: Prozesse werden immer voll abgearbeitet, bevor der nächste starten kann",
 "Memory: First-Fit, Rotating-First-Fit, Best-Fit" => "First-Fit: Belege ersten ausreichend großen Block, starte dann von vorn\nRotating-First-Fit: Wie First-Fit aber startet für nächste Allokation von der gemerkten Position\nBest-Fit: Belege kleinsten passenden Bereich",
 "Was ist DMA (Direct Memory Access) für Geräte und CPU?" => "Gesteuert über extra Hardware: DMA Modul\n- DMA erlaubt direkten Zugriff auf den flüchtigen Speicher für Geräte.\n- DMA Modul erhält Erlaubnis von CPU und sendet dann Interrupt nach Fertigstellung.",
 "Wie funktioniert I/O Buffering, was sind die Vorteile und wie viele Buffer werden meistens genutzt?" => "Bereich im Main Memory wird als Puffer reserviert.\n- Sehr schnell\n- Kann nicht auf persistenten Speicher verschoben werden.\n- Zugriff muss für ext. Hardware und Driver möglich sein\n- Übertragung kann Blockweise oder als Stream geschehen\n\nAnzahl Buffer: 0, 1, 2 (einer für In-, einer für Output) oder als Ring",
 "Was ist RAID und welche Varianten gibt es?" => "System zur Datensicherung durch die Nutzung mehrerer Festplatten.\nLevel 0: Daten in Blöcke aufgeteilt und auf 2 Platten verteilt.\n- Keine Redundanz\n- Erhöhte Zugriffsgeschwindigkeit\nLevel 1: Inhalte komplett kopiert\n- Einfache Umsetzung\nLevel 2: Daten in Bitfolgen aufgeteilt, auf größere Blöcke abgebildet und dann auf 2+ Platten verteilt.\n- Sehr schnell\nLevel 3: Extra 'Parity'-Laufwerk für Sicherung (Jedes Bit entspricht XOR-Verknüpfung der Bits der anderen Festplatten).\n- Wenig Redundanz\n- Gut für lange, sequenzielle Transfers\nLevel 4: Ähnlich zu 3, aber mit größeren Blöcken statt einzelnen Bytes\n- Vorteile wie bei Level 3\nLevel 5: Ähnlich zu 4, Aber Parity wird ebenfalls kopiert (Auf derselben Platte)\n- Gut für kleine Schreibzugriffe\nLevel 6: Wie 5, aber Parität ist immer auf 2 Platten vorhanden\n- Zusätzliche Sicherung",
 "Wo weden Dateinamen gespeichert?" => "Als Teil der Metadaten.",
 "Was ist ein Pseudo-Dateisystem?" => "Virtuelles Dateisystem. Erlaubt Zugriff wie ein normales Dateisystem.",
 "Was ist eine Inode?" => "- Enthält Metadaten der Datei inklusive Pointer auf die eigentlichen Daten.\n- Genutzt vom OS zum richtigen Erkennen von Daten und Dateityp.",
 "Contiguous allocation, Chained allocation, Indexed Allocation?" => "Varianten von Allokation für Files.\nContiguous: Datei bekommt einen großen Block an Speicher\nChained: Datei kann aus mehreren Blöcken bestehen (jeder mit Pointer zum nächsten)\nIndexed: Wie Chained, aber im Header gibt es eine Tabelle mit Indizes für schnelleren Zugriff",
 "Was sind die Unterschiede zwischen Intranet, Internet und WWW?" => "Intranet lokale Vernetzung von Computer.\nInternet: Vernetzung von weltweiten Rechnernetzwerken, die öffentlich zugänglich ist.\nWWW: Sammlung von Websites; verknüpft durch Hyperlinks; basierend auf dem Internet; Kommunikation über HTTP und HTTPS",
 "Was ist der Nachteil des ISO/OSI Modells zumm TCP/IP Modell?" => "Das OSI Modell hat mehr Schichten, jede mit Overhead. Außerdem wird es ist nicht in der Realität genutzt...",
 "Was sind die Unterschiede zwischen IPv4 und IPv6?" => "IPv4\n- Alt\n- 32 Bit Adressen\n- Lokale Adressen notwendig\nIPv6\n- 128 Bit Adressen (Also 10^38 IP-Adressen)\n- Jedes Gerät hat eine eigene Adresse\n- Noch nicht überall unterstützt",
 "read/write vs recv/send" => "- Alle funktionieren über Sockets und Files\n- ",
 "Warum ergibt sich bei der Harvard Architektur eine Leistungssteigerung?" => "Datenspeicher und Befehlsspeicher sind getrennt und haben getrennte Busse.", 
 "Erkläre Einerkomplement, Zweierkomplement, Betrag+Vorzeichen und Charakteristik." => "- 1-K: Bei negativen Zahlen sind alle Bits gekippt. Es gibt zwei Darstellungen für die 0.\n- 2-K: Bei negativen Zahlen werden alle Bits gekippt und dann wird eine 1 addiert. Es gibt nur eine Darstellung für die 0.\n- B+V: Das MSB wird für das Vorzeichen genutzt (1=Negativ), die anderen 7 Bits sind normal. Es gibt zwei Darstellungen für die 0.\n- Charakteristik:  ", 
 "Wie kann eine Pipeline im Fall von Data-Hazards schneller gemacht werden?" => "- Forwarding (EX -> EX)\n- Forwarding (MEM -> EX)\n- Bubbles \n- Reordering",
 "Was ist der Unterschied zwischen zeitlicher und örtlicher Lokalität?" => "- Zeitlich: Zuletzt benutzte Daten\n- Örtlich: Daten, die nahe beieinander stehen, wie Bytes in Arrays.",
 "Unterschied zwischen Cache-Kohärenz und -Konsistenz" => "- Kohärenz: Caches können unterschiedliche Daten beinhalten, aber die korrekte Funktionsweise wird durcch Protokolle gewährleistet.\n- Konsistenz: Caches in verschiedenen Prozessoren auf demselben Stand.",
 "Was sind die 3 Cache Kohärenz-Protokolle? (Kurze Erklärung zu jedem)" => "Write-Update\n- Kopien aller Caches sind konsistent (und damit auch kohärent)\n- Write-Invalidate\n- Bei Veränderung werden alle Kopien in anderen Caches als Invalid markiert.\nMESI-Protokoll\n- 4 Zustände: Modified, Exclusive unmodified, Shared unmodified, Invalid"
  # Fortsetzung folgt
},
{"struct sockaddr" => "sa_family_t sa_family => One of AF_INET, AF_INET6, AF_UNIX, AF_APPLETALK, AF_PACKET, AF_X25, AF_NETLINK
char sa_data[14]      => ?",
"char* inet_ntoa(struct in_addr in)" => "convert address (in network order) to string in ipv4 dot-notation.",
"ntohs(uint16_t)" => "16 bit number from network byteorder to host-byteorder.
Other in family: ntohl (32 bit)",
"struct in_addr" => "in_addr_t s_addr => Address as u32",
"htons(uint16_t)" => "16 bit number from host-byteorder to network byteorder.
Other in family: htonl (32 bit)",
"socket(int domain, int type, int protocol)" => "Creates an endpoint for communication and returns a file descriptor.
domain: AF_UNIX, AF_LOCAL, AF_INET, AF_AX25, AF_IPX, AF_APPLETALK, AF_X25, AF_INET6, AF_DECnet, AF_KEY, AF_NETLINK, AF_PACKET, AF_RDS, AF_PPPOX, AF_LLC, AF_IB, AF_MPLS, AF_CAN, AF_TIPC, AF_BLUETOOTH,mAF_ALG, AF_VSOCK, AF_KCM, AF_XDP
type: SOCK_STREAM, SOCK_DGRAM, SOCK_SEQPACKET, SOCK_RAW, SOCK_RDM, SOCK_PACKET, SOCK_NONBLOCK, SOCK_CLOEXEC
protocol: Most often 0
Success: fd
Error: -1",
"bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)" => "Assigns the address specified by addr to the socket at sockfd. addrlen is the bytesize of addr.\nSuccess: 0\nError: -1",
"listen(int sockfd, int backlog)" => "Wait until a socket wants to connects\nSuccess: 0\nError: -1",
"accept(int sockfd, struct sockaddr *addr. socklen_t *addrlen, int flags)" => "Try to let a socket connect. Should be called after a call to listen.
Success: Int >= 0 for fd of accepted socket
Error: -1",
"nice()" => "Senkt Priorität des Prozesses.",
"recv" => "",
"struct sockaddr_in" => "",
"AF_INET" => "",
"SOCK_DGRAM" => "",
"INADDR_ANY" => "",
"inet_pton" => "",
"recvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen)" => ""
}

].freeze

RAND = Random.new
NAMES = ["[BKS] ", "[RA] ", "[C] "]
loop do
  if TABLES.all?{|t| t.empty?}
    sep = "="*50
    puts "#{sep}\n     Done!\n#{sep}"
    break
  end
  i0 = RAND.rand 0...(TABLES.size)
  table = TABLES[i0]
  unless table.empty?
    i1 = RAND.rand 0...(table.size)
    key = table.keys[i1]
    print NAMES[i0]
    print key
    gets
    puts table.delete(key)
    puts
  end
end
