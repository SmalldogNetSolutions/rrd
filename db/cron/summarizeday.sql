INSERT INTO logdata_daily (stat_date, entries, wood_avail_count, wood_avail_percent,
	public_heat_count, public_heat_percent, private_heat_count, private_heat_percent,
	heat_count, heat_percent, hot_water_count, hot_water_percent, water_bottom_min,
	water_bottom_avg, water_bottom_max, water_middle_min, water_middle_avg, water_middle_max,
	light_level_min, light_level_max, light_level_sum, solar_pump_count, solar_pump_percent,
	boiler_temp_min, boiler_temp_max, tank_temp_min, tank_temp_max, boiler_run_count,
	boiler_run_percent, boiler_fire_count, boiler_fire_percent, kw_count, kw_sum, kw_today,
	thermostat1_temp_min, thermostat1_temp_max, thermostat1_setpoint_min, thermostat1_setpoint_max,
	thermostat1_count, thermostat1_percent,
	thermostat2_temp_min, thermostat2_temp_max, thermostat2_setpoint_min, thermostat2_setpoint_max,
	thermostat2_count, thermostat2_percent,
	thermostat3_temp_min, thermostat3_temp_max, thermostat3_setpoint_min, thermostat3_setpoint_max,
	thermostat3_count, thermostat3_percent)
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
	max(kw_today),
	min(thermostat1_temp),
	max(thermostat1_temp),
	min(thermostat1_setpoint),
	max(thermostat1_setpoint),
	count(thermostat1_on),
	CASE WHEN count(thermostat1_on)>0 THEN 
		count(CASE WHEN thermostat1_on IS FALSE THEN 1 ELSE NULL END)::real/
		count(thermostat1_on)::real ELSE NULL END,
	min(thermostat2_temp),
	max(thermostat2_temp),
	min(thermostat2_setpoint),
	max(thermostat2_setpoint),
	count(thermostat2_on),
	CASE WHEN count(thermostat2_on)>0 THEN 
		count(CASE WHEN thermostat2_on IS FALSE THEN 1 ELSE NULL END)::real/
		count(thermostat2_on)::real ELSE NULL END,
	min(thermostat3_temp),
	max(thermostat3_temp),
	min(thermostat3_setpoint),
	max(thermostat3_setpoint),
	count(thermostat3_on),
	CASE WHEN count(thermostat3_on)>0 THEN 
		count(CASE WHEN thermostat3_on IS FALSE THEN 1 ELSE NULL END)::real/
		count(thermostat3_on)::real ELSE NULL END
FROM logdata
WHERE date(log_ts)=date(now() - interval '1 day')
GROUP BY 1;
