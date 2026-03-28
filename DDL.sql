SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS allergene;
DROP TABLE IF EXISTS box;
DROP TABLE IF EXISTS carrello;
DROP TABLE IF EXISTS composizione_box;
DROP TABLE IF EXISTS dettaglio_ordine;
DROP TABLE IF EXISTS fattura;
DROP TABLE IF EXISTS fornitore;
DROP TABLE IF EXISTS indirizzo_utente;
DROP TABLE IF EXISTS ingrediente;
DROP TABLE IF EXISTS ingrediente_allergene;
DROP TABLE IF EXISTS ingrediente_magazzino;
DROP TABLE IF EXISTS magazzino;
DROP TABLE IF EXISTS ordine;
DROP TABLE IF EXISTS sconto;
DROP TABLE IF EXISTS sconto_box;
DROP TABLE IF EXISTS sconto_categoria;
DROP TABLE IF EXISTS spedizione;
DROP TABLE IF EXISTS utente;
DROP TABLE IF EXISTS valori_nutrizionali;

SET FOREIGN_KEY_CHECKS = 1;

create table allergene
(
    id          bigint auto_increment
        primary key,
    nome        varchar(100) not null,
    descrizione varchar(255) null,
    constraint nome
        unique (nome)
);

create table box
(
    id                 bigint auto_increment
        primary key,
    ean                varchar(13)                          not null,
    nome               varchar(255)                         not null,
    categoria          varchar(255)                         null,
    porzioni           tinyint                              not null,
    quantita_in_box    int                                  not null,
    prezzo             decimal(5, 2)                        not null,
    immagine_url       varchar(500)                         null,
    attivo             tinyint(1) default 1                 null,
    data_creazione     datetime   default CURRENT_TIMESTAMP null,
    data_aggiornamento datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint ean
        unique (ean)
);

create table fornitore
(
    id          bigint auto_increment
        primary key,
    partita_iva varchar(11)  not null,
    nome        varchar(255) not null,
    via         varchar(100) not null,
    civico      varchar(10)  not null,
    cap         varchar(5)   not null,
    citta       varchar(100) not null,
    provincia   varchar(4)   not null,
    constraint partita_iva
        unique (partita_iva)
);

create table magazzino
(
    id        bigint auto_increment
        primary key,
    nome      varchar(50)  not null,
    via       varchar(100) not null,
    civico    varchar(10)  not null,
    cap       varchar(5)   not null,
    citta     varchar(100) not null,
    provincia varchar(4)   not null,
    constraint nome
        unique (nome)
);

create table sconto
(
    id            bigint auto_increment
        primary key,
    nome          varchar(100) default 'Sconto Generico' not null,
    valore        int                                    not null,
    attivo        tinyint(1)   default 1                 not null,
    inizio_sconto date                                   not null,
    fine_sconto   date                                   not null,
    constraint chk_date_sconti
        check (`inizio_sconto` < `fine_sconto`)
);

create table utente
(
    id                 bigint auto_increment
        primary key,
    cf                 varchar(16)                           not null,
    nome               varchar(50)                           not null,
    cognome            varchar(50)                           not null,
    data_nascita       date                                  not null,
    telefono           varchar(15)                           not null,
    email              varchar(255)                          not null,
    password_c         varchar(255)                          not null,
    ruolo              varchar(20) default 'USER'            null,
    data_registrazione datetime    default CURRENT_TIMESTAMP null,
    data_aggiornamento datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint cf
        unique (cf),
    constraint email
        unique (email)
);

create table indirizzo_utente
(
    id        bigint auto_increment
        primary key,
    utente_id bigint       not null,
    stato     varchar(10)  not null,
    via       varchar(100) not null,
    civico    varchar(10)  not null,
    cap       varchar(5)   not null,
    citta     varchar(100) not null,
    provincia varchar(4)   not null,
    constraint fk_indirizzo_utente
        foreign key (utente_id) references utente (id)
            on delete cascade,
    check (`stato` in ('attivo', 'inattivo'))
);

create table ingrediente
(
    id                 bigint auto_increment
        primary key,
    ean                varchar(13)                           not null,
    fornitore_id       bigint                                not null,
    nome               varchar(255)                          not null,
    descrizione        varchar(255)                          null,
    unita_misura       varchar(10) default 'g'               not null,
    prezzo_per_unita   decimal(7, 4)                         not null,
    attivo             tinyint(1)  default 1                 null,
    data_creazione     datetime    default CURRENT_TIMESTAMP null,
    data_aggiornamento datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    peso_per_pezzo     decimal(7, 2)                         null,
    constraint ean
        unique (ean),
    constraint fk_ingrediente_fornitore
        foreign key (fornitore_id) references fornitore (id)
);

create table sconto_box
(
    sconto_id bigint not null,
    box_id    bigint not null,
    primary key (sconto_id, box_id),
    constraint fk_sconto_box_box
        foreign key (box_id) references box (id)
            on delete cascade,
    constraint fk_sconto_box_sconto
        foreign key (sconto_id) references sconto (id)
            on delete cascade
);

create table sconto_categoria
(
    sconto_id bigint       not null,
    categoria varchar(255) not null,
    primary key (sconto_id, categoria),
    constraint fk_sconto_cat_sconto
        foreign key (sconto_id) references sconto (id)
            on delete cascade
);

create table carrello
(
    id        bigint auto_increment
        primary key,
    utente_id bigint not null,
    box_id    bigint not null,
    quantita  int    not null,
    constraint fk_carrello_box
        foreign key (box_id) references box (id),
    constraint fk_carrello_utente
        foreign key (utente_id) references utente (id)
            on delete cascade
);

create table ordine
(
    id                 bigint auto_increment
        primary key,
    codice_ordine      varchar(50)                           not null,
    utente_id          bigint                                not null,
    data_ordine        datetime    default CURRENT_TIMESTAMP null,
    data_aggiornamento datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    totale_prezzo      decimal(7, 2)                         not null,
    totale_quantita    int                                   not null,
    stato_ordine       varchar(20) default 'IN_ATTESA'       null,
    constraint codice_ordine
        unique (codice_ordine),
    constraint fk_ordine_utente
        foreign key (utente_id) references utente (id),
    check (`stato_ordine` in ('IN_ATTESA', 'PAGATO', 'SPEDITO', 'CONSEGNATO', 'ANNULLATO'))
);

create table composizione_box
(
    id             bigint auto_increment
        primary key,
    box_id         bigint        not null,
    ingrediente_id bigint        not null,
    quantita       decimal(8, 2) not null,
    constraint fk_comp_box
        foreign key (box_id) references box (id)
            on delete cascade,
    constraint fk_comp_ingr
        foreign key (ingrediente_id) references ingrediente (id)
);

create table dettaglio_ordine
(
    id              bigint auto_increment
        primary key,
    ordine_id       bigint        not null,
    box_id          bigint        not null,
    quantita        int           not null,
    prezzo_unitario decimal(5, 2) not null,
    constraint fk_dettaglio_box
        foreign key (box_id) references box (id),
    constraint fk_dettaglio_ordine
        foreign key (ordine_id) references ordine (id)
            on delete cascade
);

create table fattura
(
    id               bigint auto_increment
        primary key,
    ordine_id        bigint         not null,
    metodo_pagamento varchar(50)    null,
    data_pagamento   date           null,
    importo          decimal(10, 2) null,
    constraint ordine_id
        unique (ordine_id),
    constraint fk_fattura_ordine
        foreign key (ordine_id) references ordine (id)
            on delete cascade
);

create table ingrediente_allergene
(
    ingrediente_id bigint                         not null,
    allergene_id   bigint                         not null,
    tipo_presenza  varchar(50) default 'PRESENTE' null,
    primary key (ingrediente_id, allergene_id),
    constraint fk_ingr_all_all
        foreign key (allergene_id) references allergene (id)
            on delete cascade,
    constraint fk_ingr_all_ingr
        foreign key (ingrediente_id) references ingrediente (id)
            on delete cascade
);

create table ingrediente_magazzino
(
    id             bigint auto_increment
        primary key,
    ingrediente_id bigint         not null,
    magazzino_id   bigint         not null,
    quantita       decimal(10, 2) not null,
    lotto          varchar(20)    null,
    data_ingresso  date           null,
    constraint fk_scorta_ingrediente
        foreign key (ingrediente_id) references ingrediente (id),
    constraint fk_scorta_magazzino
        foreign key (magazzino_id) references magazzino (id)
);

create table spedizione
(
    id               bigint auto_increment
        primary key,
    ordine_id        bigint                                not null,
    corriere         varchar(100)                          not null,
    stato_spedizione varchar(20) default 'IN_PREPARAZIONE' not null,
    via              varchar(100)                          not null,
    civico           varchar(10)                           not null,
    cap              varchar(5)                            not null,
    citta            varchar(100)                          not null,
    provincia        varchar(4)                            not null,
    constraint ordine_id
        unique (ordine_id),
    constraint fk_spedizione_ordine
        foreign key (ordine_id) references ordine (id)
            on delete cascade,
    check (`stato_spedizione` in ('IN_PREPARAZIONE', 'IN_TRANSITO', 'IN_CONSEGNA', 'CONSEGNATO'))
);

create table valori_nutrizionali
(
    id             bigint auto_increment
        primary key,
    ingrediente_id bigint        not null,
    proteine       decimal(5, 2) not null,
    carboidrati    decimal(5, 2) not null,
    zuccheri       decimal(5, 2) not null,
    fibre          decimal(5, 2) not null,
    grassi         decimal(5, 2) not null,
    sale           decimal(5, 2) not null,
    chilocalorie   int           not null,
    constraint ingrediente_id
        unique (ingrediente_id),
    constraint fk_valori_ingrediente
        foreign key (ingrediente_id) references ingrediente (id)
            on delete cascade,
    check (`proteine` >= 0),
    check (`carboidrati` >= 0),
    check (`zuccheri` >= 0),
    check (`fibre` >= 0),
    check (`grassi` >= 0),
    check (`sale` >= 0),
    check (`chilocalorie` >= 0)
);
