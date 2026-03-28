INSERT INTO allergene (nome, descrizione) VALUES
('Glutine', 'Cereali contenenti glutine (grano, segale, orzo, avena)'),
('Lattosio', 'Latte e prodotti a base di latte'),
('Frutta a guscio', 'Mandorle, nocciole, noci, anacardi');

INSERT INTO box (ean, nome, categoria, porzioni, quantita_in_box, prezzo, immagine_url) VALUES
('1234567890123', 'Box Pasta al Pomodoro', 'Primi Piatti', 2, 1, 12.50, 'https://img.com/box1.jpg'),
('9876543210987', 'Box Pollo e Mandorle', 'Secondi Piatti', 2, 1, 18.00, 'https://img.com/box2.jpg');

INSERT INTO fornitore (partita_iva, nome, via, civico, cap, citta, provincia) VALUES
('11223344556', 'Bio Fattorie SRL', 'Via Roma', '10', '00100', 'Roma', 'RM'),
('99887766554', 'Carne Buona SPA', 'Via Milano', '25', '20100', 'Milano', 'MI');

INSERT INTO magazzino (nome, via, civico, cap, citta, provincia) VALUES
('Magazzino Centrale', 'Via Tiburtina', '100', '00100', 'Roma', 'RM'),
('Hub Nord', 'Viale Monza', '50', '20125', 'Milano', 'MI');

INSERT INTO sconto (nome, valore, attivo, inizio_sconto, fine_sconto) VALUES
('Sconto Benvenuto', 10, 1, '2025-01-01', '2026-12-31'),
('Black Friday', 30, 1, '2025-11-20', '2025-11-30');

INSERT INTO utente (cf, nome, cognome, data_nascita, telefono, email, password_c, ruolo) VALUES
('RSSMRA80A01H501A', 'Mario', 'Rossi', '1980-01-01', '3331234567', 'mario.rossi@email.it', 'hashpwd123', 'USER'),
('VRDLGU90B02F205B', 'Luigi', 'Verdi', '1990-02-02', '3339876543', 'luigi.verdi@email.it', 'hashpwd456', 'USER');

INSERT INTO indirizzo_utente (utente_id, stato, via, civico, cap, citta, provincia) VALUES
(1, 'attivo', 'Via Garibaldi', '5', '00100', 'Roma', 'RM'),
(2, 'attivo', 'Via Dante', '12', '20100', 'Milano', 'MI');

INSERT INTO ingrediente (ean, fornitore_id, nome, descrizione, unita_misura, prezzo_per_unita, peso_per_pezzo) VALUES
('8001234567890', 1, 'Spaghetti', 'Pasta di semola di grano duro', 'g', 0.0020, null),
('8002345678901', 1, 'Passata di Pomodoro', 'Passata biologica', 'g', 0.0030, null),
('8003456789012', 2, 'Petto di Pollo', 'Petto di pollo a fette', 'g', 0.0120, null),
('8004567890123', 1, 'Mandorle Sgusciate', 'Mandorle dolci', 'g', 0.0250, null);

INSERT INTO sconto_box (sconto_id, box_id) VALUES 
(1, 1);

INSERT INTO sconto_categoria (sconto_id, categoria) VALUES 
(2, 'Secondi Piatti');

INSERT INTO carrello (utente_id, box_id, quantita) VALUES 
(1, 2, 1);

INSERT INTO ordine (codice_ordine, utente_id, totale_prezzo, totale_quantita, stato_ordine) VALUES
('ORD-2026-001', 2, 18.00, 1, 'SPEDITO');

INSERT INTO composizione_box (box_id, ingrediente_id, quantita) VALUES
(1, 1, 200.00),
(1, 2, 150.00),
(2, 3, 300.00),
(2, 4, 30.00);

INSERT INTO dettaglio_ordine (ordine_id, box_id, quantita, prezzo_unitario) VALUES
(1, 2, 1, 18.00);

INSERT INTO fattura (ordine_id, metodo_pagamento, data_pagamento, importo) VALUES
(1, 'Carta di Credito', '2026-03-28', 18.00);

INSERT INTO ingrediente_allergene (ingrediente_id, allergene_id, tipo_presenza) VALUES
(1, 1, 'PRESENTE'),
(4, 3, 'PRESENTE');

INSERT INTO ingrediente_magazzino (ingrediente_id, magazzino_id, quantita, lotto, data_ingresso) VALUES
(1, 1, 50000.00, 'L-SPA-01', '2026-01-10'),
(2, 1, 20000.00, 'L-POM-01', '2026-02-15'),
(3, 2, 15000.00, 'L-POL-01', '2026-03-20'),
(4, 2, 10000.00, 'L-MAN-01', '2026-01-05');

INSERT INTO spedizione (ordine_id, corriere, stato_spedizione, via, civico, cap, citta, provincia) VALUES
(1, 'BRT', 'IN_TRANSITO', 'Via Dante', '12', '20100', 'Milano', 'MI');

INSERT INTO valori_nutrizionali (ingrediente_id, proteine, carboidrati, zuccheri, fibre, grassi, sale, chilocalorie) VALUES
(1, 13.00, 71.00, 3.00, 3.00, 1.50, 0.01, 350), 
(2, 1.20, 4.00, 4.00, 1.50, 0.20, 0.50, 25),    
(3, 23.00, 0.00, 0.00, 0.00, 1.00, 0.10, 100),   
(4, 21.00, 22.00, 4.00, 12.00, 50.00, 0.00, 579);
