--start db/updates/2016-01-19_update.sql

ALTER TABLE loginput ADD COLUMN kw_now_g numeric(10,2);
ALTER TABLE loginput ADD COLUMN kw_today_g numeric(10,2);
ALTER TABLE loginput ADD COLUMN kw_peak_today_g numeric(10,2);
ALTER TABLE logdata ADD COLUMN kw_now_g numeric(10,2);
ALTER TABLE logdata ADD COLUMN kw_today_g numeric(10,2);
ALTER TABLE logdata ADD COLUMN kw_peak_today_g numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN kw_count_g int4;
ALTER TABLE logdata_daily ADD COLUMN kw_sum_g numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN kw_today_g numeric(10,2);

--end db/updates/2016-01-19_update.sql

