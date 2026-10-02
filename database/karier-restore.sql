-- KARIER: snapshot database 2 Oktober 2026. Import ke database KOSONG.
CREATE TABLE `residents` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`block` text NOT NULL
);
CREATE TABLE `payments` (
	`id` text PRIMARY KEY NOT NULL,
	`resident_id` text NOT NULL,
	`amount` integer NOT NULL,
	`paid_date` text NOT NULL,
	`start_month` text NOT NULL,
	`note` text DEFAULT '' NOT NULL, `channel` text DEFAULT 'cash' NOT NULL,
	FOREIGN KEY (`resident_id`) REFERENCES `residents`(`id`) ON UPDATE no action ON DELETE no action
);
CREATE TABLE `cash_entries` (
	`id` text PRIMARY KEY NOT NULL,
	`kind` text NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`description` text NOT NULL
, `channel` text DEFAULT 'cash' NOT NULL);
CREATE TABLE `loans` (
	`id` text PRIMARY KEY NOT NULL,
	`borrower` text NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`channel` text NOT NULL,
	`note` text DEFAULT '' NOT NULL
);
CREATE TABLE `repayments` (
	`id` text PRIMARY KEY NOT NULL,
	`loan_id` text NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`channel` text NOT NULL,
	FOREIGN KEY (`loan_id`) REFERENCES `loans`(`id`) ON UPDATE no action ON DELETE no action
);
CREATE TABLE `transfers` (
	`id` text PRIMARY KEY NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`from_channel` text NOT NULL,
	`to_channel` text NOT NULL,
	`note` text DEFAULT '' NOT NULL
);
INSERT INTO residents (id,name,block) VALUES ('B10','Ari','B10');
INSERT INTO residents (id,name,block) VALUES ('B11','Deddy','B11');
INSERT INTO residents (id,name,block) VALUES ('B2','Khoirul','B2');
INSERT INTO residents (id,name,block) VALUES ('B3','Yoga','B3');
INSERT INTO residents (id,name,block) VALUES ('B4','Guntur','B4');
INSERT INTO residents (id,name,block) VALUES ('B5','Arham','B5');
INSERT INTO residents (id,name,block) VALUES ('B6','Deva','B6');
INSERT INTO residents (id,name,block) VALUES ('B7','Yuni','B7');
INSERT INTO residents (id,name,block) VALUES ('B9','Yudha','B9');
INSERT INTO residents (id,name,block) VALUES ('C1','Aryo','C1');
INSERT INTO residents (id,name,block) VALUES ('C2','Mita','C2');
INSERT INTO residents (id,name,block) VALUES ('C3','Nelly','C3');
INSERT INTO residents (id,name,block) VALUES ('C4','Haris','C4');
INSERT INTO residents (id,name,block) VALUES ('C5','Dhila','C5');
INSERT INTO residents (id,name,block) VALUES ('D10','Indra','D10');
INSERT INTO residents (id,name,block) VALUES ('D11','Putri','D11');
INSERT INTO residents (id,name,block) VALUES ('D12','Sutisna','D12');
INSERT INTO residents (id,name,block) VALUES ('D13','Bawor','D13');
INSERT INTO residents (id,name,block) VALUES ('D14','Lala','D14');
INSERT INTO residents (id,name,block) VALUES ('D15','Hengky','D15');
INSERT INTO residents (id,name,block) VALUES ('D16','Ricky','D16');
INSERT INTO residents (id,name,block) VALUES ('D2','Ricky','D2');
INSERT INTO residents (id,name,block) VALUES ('D3','Nasam','D3');
INSERT INTO residents (id,name,block) VALUES ('D4','Farhan','D4');
INSERT INTO residents (id,name,block) VALUES ('D5','Imam','D5');
INSERT INTO residents (id,name,block) VALUES ('D6','Euis','D6');
INSERT INTO residents (id,name,block) VALUES ('D7','Angger','D7');
INSERT INTO residents (id,name,block) VALUES ('D8','Taufiq','D8');
INSERT INTO residents (id,name,block) VALUES ('D9','Nur','D9');
INSERT INTO residents (id,name,block) VALUES ('E10','Sintha','E10');
INSERT INTO residents (id,name,block) VALUES ('E13','Nikita','E13');
INSERT INTO residents (id,name,block) VALUES ('E14','Rian','E14');
INSERT INTO residents (id,name,block) VALUES ('E15','Nona','E15');
INSERT INTO residents (id,name,block) VALUES ('E18','Panca','E18');
INSERT INTO residents (id,name,block) VALUES ('E2','Akbar','E2');
INSERT INTO residents (id,name,block) VALUES ('E4','Lutfi','E4');
INSERT INTO residents (id,name,block) VALUES ('E6','Hendri','E6');
INSERT INTO residents (id,name,block) VALUES ('E7','Alex','E7');
INSERT INTO residents (id,name,block) VALUES ('E9','Hendra','E9');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-B10','B10',30000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-B11','B11',25000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-B2','B2',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-B5','B5',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-B6','B6',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-C1','C1',10000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-C3','C3',10000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-C5','C5',10000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-D13','D13',40000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-D15','D15',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-D16','D16',40000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-D3','D3',25000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-D6','D6',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-D7','D7',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E10','E10',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E13','E13',50000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E14','E14',100000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E15','E15',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E18','E18',20000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E4','E4',10000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E6','E6',10000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E7','E7',50000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-E9','E9',60000,'2026-09-10','2026-09','Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026','cash');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('seed-D5','D5',40000,'2026-09-11','2026-09','Imam (D5) setor melalui DANA pada 11 September 2026','DANA');
INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES ('976a780c-6b7e-48b9-9f59-feaa16618025','C4',20000,'2026-09-15','2026-09','','DANA');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-a1','expense',35000,'2026-09-10','Lampu 30 watt, 1 pcs · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-a2','expense',45000,'2026-09-10','Racun rumput, 1 liter · gotong royong','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-a3','expense',14000,'2026-09-10','Air minum isi ulang, 2 galon · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-a4','expense',8000,'2026-09-10','Kopi, 100 gram · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-a5','expense',12000,'2026-09-10','Gula, 500 gram · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-a6','expense',26000,'2026-09-10','Kopi, 1 kilogram · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-grant','income',126000,'2026-09-10','Hibah','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-opening','income',14000,'2026-09-10','Sisa kas bulan lalu','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-s1','expense',14000,'2026-09-10','Air minum isi ulang, 2 galon · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-s2','expense',16000,'2026-09-10','Gula, 500 gram · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-s3','expense',2000,'2026-09-10','Admin penarikan GoPay','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('seed-s4','expense',31000,'2026-09-10','Kopi, 1 kilogram · pos jaga','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('92409ffb-4920-493b-8802-96b8c9e69edf','expense',17500,'2026-09-30','Beli Gula Gunung Madu 1Kg (Pos Jaga)','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('c4eb7695-e19f-4102-b166-f6c1bcaf8094','expense',36000,'2026-09-30','beli kopi BADAK 600 gr','cash');
INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES ('95b25191-fa6a-4bee-a242-adef0faa540b','expense',24000,'2026-10-02','Beli kopi Badak 400 gr (pos jaga)','cash');
INSERT INTO transfers (id,amount,date,from_channel,to_channel,note) VALUES ('correction-other-wallet-275000-20260930',275000,'2026-09-30','cash','other','Penempatan kas pada dompet digital lainnya');
INSERT INTO transfers (id,amount,date,from_channel,to_channel,note) VALUES ('673969ba-9feb-42cd-9f53-b3f201a0d21a',50000,'2026-10-02','other','cash','');
