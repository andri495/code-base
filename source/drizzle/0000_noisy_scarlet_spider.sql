CREATE TABLE `cash_entries` (
	`id` text PRIMARY KEY NOT NULL,
	`kind` text NOT NULL,
	`amount` integer NOT NULL,
	`date` text NOT NULL,
	`description` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `payments` (
	`id` text PRIMARY KEY NOT NULL,
	`resident_id` text NOT NULL,
	`amount` integer NOT NULL,
	`paid_date` text NOT NULL,
	`start_month` text NOT NULL,
	`note` text DEFAULT '' NOT NULL,
	FOREIGN KEY (`resident_id`) REFERENCES `residents`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `residents` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`block` text NOT NULL
);
