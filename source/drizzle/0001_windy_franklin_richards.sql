CREATE TABLE `loans` (
	`id` text PRIMARY KEY NOT NULL,
	`borrower` text NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`channel` text NOT NULL,
	`note` text DEFAULT '' NOT NULL
);
--> statement-breakpoint
CREATE TABLE `repayments` (
	`id` text PRIMARY KEY NOT NULL,
	`loan_id` text NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`channel` text NOT NULL,
	FOREIGN KEY (`loan_id`) REFERENCES `loans`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `transfers` (
	`id` text PRIMARY KEY NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`from_channel` text NOT NULL,
	`to_channel` text NOT NULL,
	`note` text DEFAULT '' NOT NULL
);
--> statement-breakpoint
ALTER TABLE `cash_entries` ADD `channel` text DEFAULT 'cash' NOT NULL;--> statement-breakpoint
ALTER TABLE `payments` ADD `channel` text DEFAULT 'cash' NOT NULL;