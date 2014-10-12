--start db/updates/2013-06-22_update.sql

CREATE TABLE logdata_daily (
	stat_date	date unique not null,
	entries		int4 not null,
	wood_avail_count	int4 not null,
	wood_avail_percent	numeric(4,3),
	public_heat_count	int4 not null,
	public_heat_percent	numeric(4,3),
	private_heat_count	int4 not null,
	private_heat_percent numeric(4,3),
	heat_count			int4 not null,
	heat_percent		numeric(4,3),
	hot_water_count		int4 not null,
	hot_water_percent	numeric(4,3),
	water_bottom_min	numeric(10,2),
	water_bottom_avg	numeric(10,2),
	water_bottom_max	numeric(10,2),
	water_middle_min	numeric(10,2),
	water_middle_avg	numeric(10,2),
	water_middle_max	numeric(10,2),
	light_level_min		int4,
	light_level_max		int4,
	light_level_sum		int4,
	solar_pump_count	int4 not null,
	solar_pump_percent	numeric(4,3),
	boiler_temp_min		numeric(10,2),
	boiler_temp_max		numeric(10,2),
	tank_temp_min		numeric(10,2),
	tank_temp_max		numeric(10,2),
	boiler_run_count	int4 not null,
	boiler_run_percent	numeric(4,3),
	boiler_fire_count	int4 not null,
	boiler_fire_percent	numeric(4,3),
	kw_count			int4 not null,
	kw_sum				numeric(10,2),
	kw_today			numeric(10,2));
GRANT ALL ON logdata_daily TO sdnfw;

INSERT INTO logdata_daily (stat_date, entries, wood_avail_count, wood_avail_percent,
	public_heat_count, public_heat_percent, private_heat_count, private_heat_percent,
	heat_count, heat_percent, hot_water_count, hot_water_percent, water_bottom_min,
	water_bottom_avg, water_bottom_max, water_middle_min, water_middle_avg, water_middle_max,
	light_level_min, light_level_max, light_level_sum, solar_pump_count, solar_pump_percent,
	boiler_temp_min, boiler_temp_max, tank_temp_min, tank_temp_max, boiler_run_count,
	boiler_run_percent, boiler_fire_count, boiler_fire_percent, kw_count, kw_sum, kw_today)
SELECT date(log_ts) as stat_date, count(log_ts) as entries,
	count(wood_avail),
	CASE WHEN count(wood_avail)>0 THEN 
		count(CASE WHEN wood_avail IS FALSE THEN 1 ELSE NULL END)::real/
		count(wood_avail)::real ELSE NULL END,
	count(public_heat),
	CASE WHEN count(public_heat)>0 THEN 
		count(CASE WHEN public_heat IS FALSE THEN 1 ELSE NULL END)::real/
		count(public_heat)::real ELSE NULL END,
	count(private_heat),
	CASE WHEN count(private_heat)>0 THEN 
		count(CASE WHEN private_heat IS FALSE THEN 1 ELSE NULL END)::real/
		count(private_heat)::real ELSE NULL END,
	count(COALESCE(private_heat,public_heat)),
	CASE WHEN count(COALESCE(private_heat,public_heat))>0 THEN 
		count(CASE WHEN private_heat IS FALSE OR public_heat IS FALSE THEN 1 ELSE NULL END)::real/
		count(COALESCE(private_heat,public_heat))::real ELSE NULL END,
	count(hot_water),
	CASE WHEN count(hot_water)>0 THEN 
		count(CASE WHEN hot_water IS FALSE THEN 1 ELSE NULL END)::real/
		count(hot_water)::real ELSE NULL END,
	min(water_bottom), avg(water_bottom), max(water_bottom),
	min(water_middle), avg(water_middle), max(water_middle),
	min(light_level), max(light_level), sum(light_level),
	count(solar_pump),
	CASE WHEN count(solar_pump)>0 THEN 
		count(CASE WHEN solar_pump IS FALSE THEN 1 ELSE NULL END)::real/
		count(solar_pump)::real ELSE NULL END,
	min(boiler_temp), max(boiler_temp),
	min(tank_temp), max(tank_temp),
	count(boiler_run),
	CASE WHEN count(boiler_run)>0 THEN 
		count(CASE WHEN boiler_run IS FALSE THEN 1 ELSE NULL END)::real/
		count(boiler_run)::real ELSE NULL END,
	count(boiler_fire),
	CASE WHEN count(boiler_fire)>0 THEN 
		count(CASE WHEN boiler_fire IS FALSE THEN 1 ELSE NULL END)::real/
		count(boiler_fire)::real ELSE NULL END,
	count(kw_now),
	sum(kw_now/60),
	max(kw_today)
FROM logdata
WHERE log_ts < date(now())
GROUP BY 1;

--end db/updates/2013-06-22_update.sql

