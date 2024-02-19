CREATE TABLE sales.dev_staged.amazon_sale_report (
	"index"					integer,
	"Order ID"				text,
	"Date"					text,
	"Status"				text,
	"Fulfilment"			text,
	"Sales Channel"			text,
	"ship-service-level"	text,
	"Style"					text,
	"SKU"					text,
	"Category"				text,
	"Size"					text,
	"ASIN"					text,
	"Courier Status"		text,
	"Qty"					integer,
	"currency"				text,
	"Amount"				float8,
	"ship-city"				text,
	"ship-state"			text,
	"ship-postal-code"		text,
	"ship-country"			text,
	"promotion-ids"			text,
	"B2B"					boolean,
	"fulfilled-by"			text,
	"Unnamed: 22"			text,
	PRIMARY KEY ("index")
    )
;


select * from sales.dev_staged.amazon_sale_report;


