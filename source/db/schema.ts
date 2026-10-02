import { integer, sqliteTable, text } from "drizzle-orm/sqlite-core";
export const residents = sqliteTable("residents", {
  id: text("id").primaryKey(), name: text("name").notNull(), block: text("block").notNull(),
});
export const payments = sqliteTable("payments", {
  id: text("id").primaryKey(), residentId: text("resident_id").notNull().references(() => residents.id),
  amount: integer("amount").notNull(), paidDate: text("paid_date").notNull(),
  startMonth: text("start_month").notNull(), note: text("note").notNull().default(""),
  channel: text("channel").notNull().default("cash"),
});
export const cashEntries = sqliteTable("cash_entries", {
  id: text("id").primaryKey(), kind: text("kind").notNull(), amount: integer("amount").notNull(),
  date: text("date").notNull(), description: text("description").notNull(),
  channel: text("channel").notNull().default("cash"),
});
export const loans = sqliteTable("loans", {
  id: text("id").primaryKey(), borrower: text("borrower").notNull(), amount: integer("amount").notNull(),
  date: text("date").notNull(), channel: text("channel").notNull(), note: text("note").notNull().default(""),
});
export const repayments = sqliteTable("repayments", {
  id: text("id").primaryKey(), loanId: text("loan_id").notNull().references(() => loans.id),
  amount: integer("amount").notNull(), date: text("date").notNull(), channel: text("channel").notNull(),
});
export const transfers = sqliteTable("transfers", {
  id: text("id").primaryKey(), amount: integer("amount").notNull(), date: text("date").notNull(),
  fromChannel: text("from_channel").notNull(), toChannel: text("to_channel").notNull(),
  note: text("note").notNull().default(""),
});
