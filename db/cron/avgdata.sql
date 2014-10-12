INSERT INTO logdata (log_ts, wood_avail, public_heat, private_heat, hot_water, water_bottom, water_middle,
	light_level, solar_pump, boiler_temp, tank_temp, boiler_run, boiler_fire, aquistat, kw_now, 
	kw_today, kw_peak_today, thermostat1_temp, thermostat2_temp, thermostat3_temp,
	thermostat1_db_setpoint, thermostat1_setpoint, thermostat1_on,
	thermostat2_db_setpoint, thermostat2_setpoint, thermostat2_on,
	thermostat3_db_setpoint, thermostat3_setpoint, thermostat3_on)
SELECT date_trunc('minute',log_ts), 
	bool_and(wood_avail) as wood_avail, 
	bool_and(public_heat) as public_heat,
	bool_and(private_heat) as private_heat,
	bool_and(hot_water) as hot_water,
	avg(water_bottom)::numeric(10,2) as water_bottom,
	avg(water_middle)::numeric(10,2) as water_middle,
	avg(light_level)::int4 as light_level,
	bool_and(solar_pump) as solar_pump,
	avg(boiler_temp)::numeric(10,2) as boiler_temp,
	avg(tank_temp)::numeric(10,2) as tank_temp,
	bool_and(boiler_run) as boiler_run,
	bool_and(boiler_fire) as boiler_fire,
	bool_and(aquistat) as aquistat,
	avg(kw_now)::numeric(10,2) as kw_now,
	max(kw_today)::numeric(10,2) as kw_today,
	max(kw_peak_today)::numeric(10,2) as kw_peak_today,
	avg(thermostat1_temp)::numeric(10,2) as thermostat1_temp,
	avg(thermostat2_temp)::numeric(10,2) as thermostat2_temp,
	avg(thermostat3_temp)::numeric(10,2) as thermostat3_temp,
	avg(thermostat1_db_setpoint)::int4 as thermostat1_db_setpoint,
	avg(thermostat1_setpoint)::int4 as thermostat1_setpoint,
	bool_and(thermostat1_on) as thermostat1_on,
	avg(thermostat2_db_setpoint)::int4 as thermostat2_db_setpoint,
	avg(thermostat2_setpoint)::int4 as thermostat2_setpoint,
	bool_and(thermostat2_on) as thermostat2_on,
	avg(thermostat3_db_setpoint)::int4 as thermostat3_db_setpoint,
	avg(thermostat3_setpoint)::int4 as thermostat3_setpoint,
	bool_and(thermostat3_on) as thermostat3_on
FROM loginput
WHERE log_ts < date_trunc('minute',now())
GROUP BY 1
ORDER BY 1;

DELETE FROM loginput
WHERE log_ts < date_trunc('minute',now());
