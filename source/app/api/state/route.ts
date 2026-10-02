import { env } from "cloudflare:workers";
import source from "../../../data-source.json";

export const runtime = "edge";
type DB = D1Database;
const channels=["cash","DANA","OVO","GoPay","bank","other"] as const;
const validChannel=(c:string)=>channels.includes(c as typeof channels[number]);
const serial=(s:string)=>Number(s.slice(0,4))*12+Number(s.slice(5,7));
const validDate=(s:string)=>/^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/.test(s)&&!Number.isNaN(Date.parse(`${s}T00:00:00Z`));
const seedEntries = [
  ["seed-opening", "income", 14000, "2026-09-10", "Sisa kas bulan lalu"],
  ["seed-grant", "income", 126000, "2026-09-10", "Hibah"],
  ["seed-a1", "expense", 35000, "2026-09-10", "Lampu 30 watt, 1 pcs · pos jaga"],
  ["seed-a2", "expense", 45000, "2026-09-10", "Racun rumput, 1 liter · gotong royong"],
  ["seed-a3", "expense", 14000, "2026-09-10", "Air minum isi ulang, 2 galon · pos jaga"],
  ["seed-a4", "expense", 8000, "2026-09-10", "Kopi, 100 gram · pos jaga"],
  ["seed-a5", "expense", 12000, "2026-09-10", "Gula, 500 gram · pos jaga"],
  ["seed-a6", "expense", 26000, "2026-09-10", "Kopi, 1 kilogram · pos jaga"],
  ["seed-s1", "expense", 14000, "2026-09-10", "Air minum isi ulang, 2 galon · pos jaga"],
  ["seed-s2", "expense", 16000, "2026-09-10", "Gula, 500 gram · pos jaga"],
  ["seed-s3", "expense", 2000, "2026-09-10", "Admin penarikan GoPay"],
  ["seed-s4", "expense", 31000, "2026-09-10", "Kopi, 1 kilogram · pos jaga"],
] as const;

async function ensureSeed(db: DB) {
  if(!(await db.prepare("SELECT id FROM residents WHERE id='B2'").first())) {
   const statements = [
    ...source.map(p => db.prepare("INSERT OR IGNORE INTO residents (id,name,block) VALUES (?,?,?)").bind(p.block,p.name,p.block)),
    ...source.filter(p=>p.prepaid>0).map(p=>db.prepare("INSERT OR IGNORE INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES (?,?,?,?,?,?,?)").bind(`seed-${p.block}`,p.block,p.prepaid,p.block==="D5"?"2026-09-11":"2026-09-10","2026-09",p.block==="D5"?"Imam (D5) setor melalui DANA pada 11 September 2026":"Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026",p.block==="D5"?"DANA":"cash")),
    ...seedEntries.map(e=>db.prepare("INSERT OR IGNORE INTO cash_entries (id,kind,amount,date,description) VALUES (?,?,?,?,?)").bind(...e)),
  ];
   await db.batch(statements);
  }
  // Koreksi tanggal perkiraan pada data awal yang tanggal aslinya tidak tercantum.
  // Kondisi tanggal dan catatan menjaga transaksi bertanggal pasti tetap utuh.
  await db.batch([
    db.prepare("UPDATE payments SET paid_date='2026-09-10',note='Saldo awal dari PDF; tanggal tidak dirinci, ditetapkan 10 September 2026' WHERE id LIKE 'seed-%' AND id<>'seed-D5' AND paid_date='2026-08-01' AND note='Saldo awal dari PDF; tanggal penerimaan tidak dirinci'"),
    db.prepare("UPDATE cash_entries SET date='2026-09-10' WHERE id IN ('seed-opening','seed-grant','seed-a1','seed-a2','seed-a3','seed-a4','seed-a5','seed-a6','seed-s1','seed-s2','seed-s3','seed-s4') AND date IN ('2026-08-01','2026-08-15','2026-09-15')"),
  ]);
  // Koreksi pemilik 30 September 2026: hapus dua pinjaman dan pengembaliannya,
  // pertahankan Rp275.000 sebagai kas pada dompet digital lainnya.
  const correctionId="correction-other-wallet-275000-20260930";
  if(!(await db.prepare("SELECT id FROM transfers WHERE id=?").bind(correctionId).first())) {
    await db.batch([
      db.prepare("DELETE FROM repayments WHERE loan_id IN ('request-sutisna-d12-20260926','request-makwo-d4-20260924') AND NOT EXISTS (SELECT 1 FROM transfers WHERE id=?)").bind(correctionId),
      db.prepare("DELETE FROM loans WHERE id IN ('request-sutisna-d12-20260926','request-makwo-d4-20260924') AND NOT EXISTS (SELECT 1 FROM transfers WHERE id=?)").bind(correctionId),
      db.prepare("DELETE FROM transfers WHERE id IN ('1b5d3323-b051-44ab-927c-bc1b2a2de784','edcf2c99-220e-4d98-a9bd-05256df5a9c3') AND NOT EXISTS (SELECT 1 FROM transfers WHERE id=?)").bind(correctionId),
      db.prepare("INSERT OR IGNORE INTO transfers (id,amount,date,from_channel,to_channel,note) VALUES (?,275000,'2026-09-30','cash','other','Penempatan kas pada dompet digital lainnya')").bind(correctionId),
    ]);
  }
}

type Pay={amount:number;paidDate:string;startMonth:string;channel:string};
type Cash={kind:string;amount:number;date:string;channel:string};
type Loan={id:string;amount:number;date:string;channel:string};
type Repayment={loanId:string;amount:number;date:string;channel:string};
type Transfer={amount:number;date:string;fromChannel:string;toChannel:string};
async function snapshot(db:DB,date:string) {
  const [p,e,l,r,t]=await Promise.all([
    db.prepare("SELECT amount,paid_date AS paidDate,start_month AS startMonth,channel FROM payments WHERE paid_date<=?").bind(date).all<Pay>(),
    db.prepare("SELECT kind,amount,date,channel FROM cash_entries WHERE date<=?").bind(date).all<Cash>(),
    db.prepare("SELECT id,amount,date,channel FROM loans WHERE date<=?").bind(date).all<Loan>(),
    db.prepare("SELECT loan_id AS loanId,amount,date,channel FROM repayments WHERE date<=?").bind(date).all<Repayment>(),
    db.prepare("SELECT amount,date,from_channel AS fromChannel,to_channel AS toChannel FROM transfers WHERE date<=?").bind(date).all<Transfer>(),
  ]);
  const balances:Record<string,number>=Object.fromEntries(channels.map(c=>[c,0]));
  for(const x of p.results)balances[x.channel]=(balances[x.channel]||0)+x.amount;
  for(const x of e.results)balances[x.channel]=(balances[x.channel]||0)+(x.kind==="income"?x.amount:-x.amount);
  for(const x of l.results)balances[x.channel]=(balances[x.channel]||0)-x.amount;
  for(const x of r.results)balances[x.channel]=(balances[x.channel]||0)+x.amount;
  for(const x of t.results){balances[x.fromChannel]=(balances[x.fromChannel]||0)-x.amount;balances[x.toChannel]=(balances[x.toChannel]||0)+x.amount;}
  const period=serial(date),blocked=p.results.reduce((sum,x)=>sum+x.amount-Math.min(x.amount,Math.max(0,period-serial(x.startMonth)+1)*5000),0);
  return {balances,available:Object.values(balances).reduce((a,b)=>a+b,0)-blocked,loans:l.results,repayments:r.results};
}

function problem(message: string, status=400) { return Response.json({error:message},{status}); }
function sameOrigin(req: Request) {
  const origin=req.headers.get("origin");
  return !origin || origin===new URL(req.url).origin;
}

export async function GET() {
  try {
    const db=env.DB as DB;
    await ensureSeed(db);
    const [residents,payments,entries,loans,repayments,transfers]=await Promise.all([
      db.prepare("SELECT id,name,block FROM residents ORDER BY block").all(),
      db.prepare("SELECT id,resident_id AS residentId,amount,paid_date AS paidDate,start_month AS startMonth,note,channel FROM payments ORDER BY paid_date,id").all(),
      db.prepare("SELECT id,kind,amount,date,description,channel FROM cash_entries ORDER BY date,id").all(),
      db.prepare("SELECT id,borrower,amount,date,channel,note FROM loans ORDER BY date,id").all(),
      db.prepare("SELECT id,loan_id AS loanId,amount,date,channel FROM repayments ORDER BY date,id").all(),
      db.prepare("SELECT id,amount,date,from_channel AS fromChannel,to_channel AS toChannel,note FROM transfers ORDER BY date,id").all(),
    ]);
    return Response.json({residents:residents.results,payments:payments.results,entries:entries.results,loans:loans.results,repayments:repayments.results,transfers:transfers.results,rate:5000});
  } catch(e) { console.error(e);return problem("Data belum dapat dimuat. Silakan coba lagi.",503); }
}

export async function POST(req: Request) {
  if(!sameOrigin(req))return problem("Asal permintaan tidak sesuai.",403);
  try {
    const db=env.DB as DB;
    await ensureSeed(db);
    const input=await req.json() as Record<string,unknown>;
    const kind=String(input.kind||"");
    if(kind==="resident") {
      const name=String(input.name||"").trim(), block=String(input.block||"").trim().toUpperCase();
      if(!name||name.length>100||!block||block.length>20)return problem("Nama dan blok wajib diisi (maksimal 100 dan 20 karakter).");
      const existing=await db.prepare("SELECT id FROM residents WHERE block=?").bind(block).first();
      if(existing)return problem("Blok tersebut sudah terdaftar.");
      await db.prepare("INSERT INTO residents (id,name,block) VALUES (?,?,?)").bind(block,name,block).run();
    } else if(kind==="payment") {
      const residentId=String(input.residentId||""),amount=Number(input.amount),paidDate=String(input.paidDate||""),startMonth=String(input.startMonth||""),channel=String(input.channel||"cash");
      if(!Number.isSafeInteger(amount)||amount<=0||amount%5000!==0||amount>100000000)return problem("Nominal harus kelipatan Rp5.000 dan lebih besar dari nol.");
      if(!validDate(paidDate)||!validChannel(channel)||!/^\d{4}-(0[1-9]|1[0-2])$/.test(startMonth)||startMonth<paidDate.slice(0,7))return problem("Periksa tanggal bayar, tempat uang diterima, dan bulan mulai.");
      if(!(await db.prepare("SELECT id FROM residents WHERE id=?").bind(residentId).first()))return problem("Warga tidak ditemukan.");
      const existing=await db.prepare("SELECT amount,start_month AS startMonth FROM payments WHERE resident_id=?").bind(residentId).all();
      const serial=(s:string)=>Number(s.slice(0,4))*12+Number(s.slice(5,7));
      const start=serial(startMonth),end=start+amount/5000;
      if(existing.results.some(p=>start<serial(String(p.startMonth))+Number(p.amount)/5000 && serial(String(p.startMonth))<end))return problem("Periode ini sudah dibayar. Pilih bulan berikutnya agar tidak tercatat ganda.");
      await db.prepare("INSERT INTO payments (id,resident_id,amount,paid_date,start_month,note,channel) VALUES (?,?,?,?,?,?,?)").bind(crypto.randomUUID(),residentId,amount,paidDate,startMonth,String(input.note||"").trim().slice(0,180),channel).run();
    } else if(kind==="entry") {
      const type=String(input.type),amount=Number(input.amount),date=String(input.date||""),description=String(input.description||"").trim(),channel=String(input.channel||"cash");
      if(!["income","expense"].includes(type)||!Number.isSafeInteger(amount)||amount<=0||amount>100000000||!validDate(date)||!validChannel(channel)||!description||description.length>180)return problem("Lengkapi jenis, tanggal, tempat uang, nominal, dan keterangan transaksi.");
      if(type==="expense") {
        const position=await snapshot(db,date);
        if(amount>position.available)return problem(`Kas tersedia pada tanggal tersebut hanya Rp${position.available.toLocaleString("id-ID")}. Uang muka bulan berikutnya masih diblokir.`);
        if(amount>position.balances[channel])return problem(`Saldo ${channel} tidak mencukupi. Pindahkan dana antar tempat penyimpanan terlebih dahulu.`);
      }
      await db.prepare("INSERT INTO cash_entries (id,kind,amount,date,description,channel) VALUES (?,?,?,?,?,?)").bind(crypto.randomUUID(),type,amount,date,description,channel).run();
    } else if(kind==="loan") {
      const borrower=String(input.borrower||"").trim(),amount=Number(input.amount),date=String(input.date||""),channel=String(input.channel||""),note=String(input.note||"").trim();
      if(!borrower||borrower.length>100||!Number.isSafeInteger(amount)||amount<=0||amount>100000000||!validDate(date)||!validChannel(channel))return problem("Isi nama peminjam, tanggal, nominal, dan sumber uang.");
      const position=await snapshot(db,date);
      const physical=Object.values(position.balances).reduce((a,b)=>a+b,0);
      if(amount>physical)return problem(`Saldo kas riil yang dapat dipinjam hanya Rp${physical.toLocaleString("id-ID")}.`);
      if(amount>position.balances[channel])return problem(`Saldo ${channel} tidak mencukupi untuk pinjaman.`);
      await db.prepare("INSERT INTO loans (id,borrower,amount,date,channel,note) VALUES (?,?,?,?,?,?)").bind(crypto.randomUUID(),borrower,amount,date,channel,note.slice(0,180)).run();
    } else if(kind==="repayment") {
      const loanId=String(input.loanId||""),amount=Number(input.amount),date=String(input.date||""),channel=String(input.channel||"");
      if(!Number.isSafeInteger(amount)||amount<=0||amount>100000000||!validDate(date)||!validChannel(channel))return problem("Isi tanggal, nominal, dan tempat penerimaan pengembalian.");
      const loan=await db.prepare("SELECT amount,date FROM loans WHERE id=?").bind(loanId).first<{amount:number;date:string}>();
      if(!loan||date<loan.date)return problem("Pinjaman tidak ditemukan atau tanggal pengembalian sebelum tanggal pinjam.");
      const previous=await db.prepare("SELECT COALESCE(SUM(amount),0) AS total FROM repayments WHERE loan_id=?").bind(loanId).first<{total:number}>();
      if(amount>loan.amount-(previous?.total??0))return problem("Pengembalian melebihi sisa pinjaman.");
      await db.prepare("INSERT INTO repayments (id,loan_id,amount,date,channel) VALUES (?,?,?,?,?)").bind(crypto.randomUUID(),loanId,amount,date,channel).run();
    } else if(kind==="transfer") {
      const amount=Number(input.amount),date=String(input.date||""),from=String(input.fromChannel||""),to=String(input.toChannel||"");
      if(!Number.isSafeInteger(amount)||amount<=0||amount>100000000||!validDate(date)||!validChannel(from)||!validChannel(to)||from===to)return problem("Isi nominal, tanggal, serta asal dan tujuan uang yang berbeda.");
      const position=await snapshot(db,date);
      if(amount>position.balances[from])return problem(`Saldo ${from} tidak mencukupi untuk pemindahan.`);
      await db.prepare("INSERT INTO transfers (id,amount,date,from_channel,to_channel,note) VALUES (?,?,?,?,?,?)").bind(crypto.randomUUID(),amount,date,from,to,String(input.note||"").trim().slice(0,180)).run();
    } else return problem("Jenis data tidak dikenali.");
    return Response.json({ok:true});
  } catch(e) { console.error(e);return problem("Data belum dapat disimpan. Silakan coba lagi.",503); }
}

export async function DELETE(req:Request) {
  if(!sameOrigin(req))return problem("Asal permintaan tidak sesuai.",403);
  try {
    const {kind,id}=await req.json() as {kind:string,id:string};
    if(!id||id.startsWith("seed-"))return problem("Data awal dari lampiran tidak dapat dihapus di sini.");
    const table=kind==="payment"?"payments":kind==="entry"?"cash_entries":null;
    if(!table)return problem("Jenis data tidak dikenali.");
    await (env.DB as DB).prepare(`DELETE FROM ${table} WHERE id=?`).bind(id).run();
    return Response.json({ok:true});
  } catch(e) { console.error(e);return problem("Data belum dapat dihapus.",503); }
}
