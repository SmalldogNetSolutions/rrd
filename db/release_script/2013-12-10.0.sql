--start db/updates/2013-12-10_update.sql

ALTER TABLE loginput ADD COLUMN thermostat1_temp numeric(10,2);
ALTER TABLE logdata ADD COLUMN thermostat1_temp numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN thermostat1_temp_min numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN thermostat1_temp_max numeric(10,2);

--end db/updates/2013-12-10_update.sql

