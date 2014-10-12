CREATE TABLE keyvals (
	key			varchar(30) unique not null,
	value_int	int4,
	value_str	varchar(255),
	value_ts	timestamp);
GRANT ALL ON keyvals TO sdnfw;

CREATE TABLE valuelog (
	key		varchar(30) not null,
	value_int	int4 not null,
	start_ts	timestamp not null,
	end_ts		timestamp not null default now());
GRANT ALL ON valuelog TO sdnfw;

