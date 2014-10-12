CREATE TABLE rrd_thermostats (
	code	varchar(30) unique not null,
	n	int4 unique not null,
	setpoint	int4 not null);
GRANT ALL ON rrd_thermostats TO sdnfw;
INSERT INTO rrd_thermostats (code, n, setpoint) VALUES
('publicthermostat',1,67),
('privatethermostat',2,67),
('garage',3,53);

ALTER TABLE loginput ADD COLUMN thermostat1_db_setpoint int4;
ALTER TABLE loginput ADD COLUMN thermostat1_setpoint int4;
ALTER TABLE loginput ADD COLUMN thermostat1_on boolean;
ALTER TABLE logdata ADD COLUMN thermostat1_db_setpoint int4;
ALTER TABLE logdata ADD COLUMN thermostat1_setpoint int4;
ALTER TABLE logdata ADD COLUMN thermostat1_on boolean;
ALTER TABLE logdata_daily ADD COLUMN thermostat1_setpoint_min int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat1_setpoint_max int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat1_count int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat1_percent numeric(4,3);

ALTER TABLE loginput ADD COLUMN thermostat2_temp numeric(10,2);
ALTER TABLE loginput ADD COLUMN thermostat2_db_setpoint int4;
ALTER TABLE loginput ADD COLUMN thermostat2_setpoint int4;
ALTER TABLE loginput ADD COLUMN thermostat2_on boolean;
ALTER TABLE logdata ADD COLUMN thermostat2_temp numeric(10,2);
ALTER TABLE logdata ADD COLUMN thermostat2_db_setpoint int4;
ALTER TABLE logdata ADD COLUMN thermostat2_setpoint int4;
ALTER TABLE logdata ADD COLUMN thermostat2_on boolean;
ALTER TABLE logdata_daily ADD COLUMN thermostat2_temp_min numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN thermostat2_temp_max numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN thermostat2_setpoint_min int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat2_setpoint_max int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat2_count int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat2_percent numeric(4,3);

ALTER TABLE loginput ADD COLUMN thermostat3_temp numeric(10,2);
ALTER TABLE loginput ADD COLUMN thermostat3_db_setpoint int4;
ALTER TABLE loginput ADD COLUMN thermostat3_setpoint int4;
ALTER TABLE loginput ADD COLUMN thermostat3_on boolean;
ALTER TABLE logdata ADD COLUMN thermostat3_temp numeric(10,2);
ALTER TABLE logdata ADD COLUMN thermostat3_db_setpoint int4;
ALTER TABLE logdata ADD COLUMN thermostat3_setpoint int4;
ALTER TABLE logdata ADD COLUMN thermostat3_on boolean;
ALTER TABLE logdata_daily ADD COLUMN thermostat3_temp_min numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN thermostat3_temp_max numeric(10,2);
ALTER TABLE logdata_daily ADD COLUMN thermostat3_setpoint_min int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat3_setpoint_max int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat3_count int4;
ALTER TABLE logdata_daily ADD COLUMN thermostat3_percent numeric(4,3);

UPDATE logdata_daily SET thermostat1_count=0;
UPDATE logdata_daily SET thermostat2_count=0;
UPDATE logdata_daily SET thermostat3_count=0;
ALTER TABLE logdata_daily ALTER COLUMN thermostat1_count SET NOT NULL;
ALTER TABLE logdata_daily ALTER COLUMN thermostat2_count SET NOT NULL;
ALTER TABLE logdata_daily ALTER COLUMN thermostat3_count SET NOT NULL;
