/****** Object:  StoredProcedure [dbo].[sp_ani_stats]    Script Date: 2022-06-02 1:34:32 PM ******/
DROP PROCEDURE [dbo].[sp_ani_stats]
GO
/****** Object:  StoredProcedure [dbo].[sp_ani_stats]    Script Date: 2022-06-02 1:34:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_ani_stats]

as

--DEPENDENCY: The cdr_in table must be installed. https://github.com/sip40/scammerscanner/blob/main/tsql/dbo.cdr_in.Table.sql
--DEPENDENCY: The npanxx table must be installed. https://github.com/sip40/scammerscanner/blob/main/tsql/dbo.npanxx.Table.sql
--DEPENDENCY: If using Invalid ANI Ratio then the npanxx table must be populated. https://drive.google.com/file/d/1tORbOkeikigoinJf1up7Tv3XWRzhDccB/view?usp=sharing
--PLACEHOLDER: If using YouMail for real-time blocking replace the '666' in the queries below with your internal blocking code.
--FORUM: Join our Discord server at https://discord.gg/pT83xVF4XF
--QUESTIONS? If you have any questions do not hesitate to email us at dean@sip40.com



--STEP 1
--Run this query to return high level ANI stats.
select right(ani, 10) as 'ani'
, account_id
, count(*) as 'attempts'
, (sum(case sip_code when 200 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 as 'asr'
, str(((sum(case when left(right(ani, 10), 6) = left(right(dnis, 10), 6) then 1 else 0 end)) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'neighborhood_spoofing_ratio'
, case when ((sum(case when left(right(ani, 10), 6) = left(right(dnis, 10), 6) then 1 else 0 end)) / cast(count(*) as numeric(20, 10))) * 100 >= 5 then 'worth investigating - https://github.com/sip40/scammerscanner/wiki/Neighborhood-Spoofing-Ratio' else '' end as 'neighborhood_spoofing_ratio_result'
, str((sum(case sip_code when 403 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '403_ratio'
, case when (sum(case sip_code when 403 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 3 then 'worth investigating - https://github.com/sip40/scammerscanner/wiki/403-Ratio' else '' end as '403_ratio_result'
, str((sum(case sip_code when 404 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '404_ratio'
, case when (sum(case sip_code when 404 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 2 then 'worth investigating - https://github.com/sip40/scammerscanner/wiki/404-Ratio' else '' end as '404_ratio_result'
, str((sum(case sip_code when 486 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '486_ratio'
, case when (sum(case sip_code when 486 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 3 then 'worth investigating - https://github.com/sip40/scammerscanner/wiki/486-Ratio' else '' end as '486_ratio_result'
, str((sum(case sip_code when 603 then 1 when 607 then 1 when 608 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '603/607/608_ratio'
, case when (sum(case sip_code when 603 then 1 when 607 then 1 when 608 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 3 then 'worth investigating - https://github.com/sip40/scammerscanner/wiki/603-607-608-Ratio' else '' end as '603/607/608_ratio_result'
, str((sum(case sip_code when 666 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'youmail_scam_ratio'
, case when (sum(case sip_code when 666 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 > 0 then 'worth investigating - https://github.com/sip40/scammerscanner/wiki/YouMail-Scam-Ratio' else '' end as 'youmail_scam_ratio_result'
from cdr_in
--where account_id = '123'
--where signal_ip_org = '0.0.0.0'
--where media_ip_orig = '0.0.0.0'
group by right(ani, 10), account_id
order by count(*) desc



--STEP 2 
--Run the following 3 queries to calculate Repeated DNIS Distribution
drop table if exists rep_repeated_dnis_ani

select right(ani, 10) as 'ani', account_id, right(dnis, 10) as 'dnis', count(*) as 'attempts'
into rep_repeated_dnis_ani
from cdr_in
--where account_id = '123'
--where signal_ip_org = '0.0.0.0'
--where media_ip_orig = '0.0.0.0'
group by right(ani, 10), account_id, right(dnis, 10)

select ani
, account_id
, sum(attempts) as 'attempts'
, str((sum(case attempts when 1 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_1%'
, str((sum(case attempts when 2 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_2%'
, str((sum(case attempts when 3 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_3%'
, str((sum(case attempts when 4 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_4%'
, str((sum(case attempts when 5 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_5%'
, str((sum(case attempts when 6 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_6%'
, str((sum(case attempts when 7 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_7%'
, str((sum(case attempts when 8 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_8%'
, str((sum(case attempts when 9 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_9%'
, str((sum(case when attempts >= 10 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_10+%'
from rep_repeated_dnis_ani
group by ani, account_id
order by sum(attempts) desc



--STEP 3
--Run the following 3 queries to perform RVM Detection
drop table if exists rep_rvm_ani

select right(ani, 10) as 'ani'
, account_id
, cast(attempt_date_time as smalldatetime) as 'attempt_date_time'
, right(dnis, 10) as 'dnis'
, count(*) as 'attempts'
into rep_rvm_ani
from cdr_in
--where account_id = '123'
--where signal_ip_org = '0.0.0.0'
--where media_ip_orig = '0.0.0.0'
group by right(ani, 10), account_id, cast(attempt_date_time as smalldatetime), right(dnis, 10)

select ani
, account_id
, sum(attempts) as 'attempts'
, sum(case attempts when 2 then 1 else 0 end) as 'rvm_attempts'
, str((sum(case attempts when 2 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'rvm%'
from rep_rvm_ani
group by ani, account_id
order by sum(attempts) desc



--STEP 4
--Run these queries to perform matching against the FTC DNC API.
--DEPENDENCY:  The ftp_dnc table must be populated from https://www.ftc.gov/policy-notices/open-government/data-sets/do-not-call-data
--We recommend using the last 7 days of the FTC DNC API recordset.
declare @total_complaints int = (select count(*) from ftc_dnc)

select right(ani, 10) as 'ani'
, account_id
, count(distinct(ftc.complaint_id)) as 'ftc_complaints'
, str(count(distinct(ftc.complaint_id)) / cast(@total_complaints as numeric(20, 10)) * 100, 5, 2) as '%_of_total_ftc_complaints'
, case when count(distinct(ftc.complaint_id)) / cast(@total_complaints as numeric(20, 10)) * 100 >= 0.01 then 'worth investigating - https://github.com/sip40/scammerscanner/wiki/Federal-Trade-Commission-DNC-and-Robocall-API' else '' end as '%_of_total_ftc_complaints_result'
from cdr_in as cdr
left outer join ftc_dnc as ftc on right(cdr.ani, 10) = right(ftc.[Company_Phone_Number], 10)
--where account_id = '123'
--where signal_ip_org = '0.0.0.0'
--where media_ip_orig = '0.0.0.0'
group by right(ani, 10), account_id
having count(distinct(ftc.complaint_id)) >= 1
order by count(distinct(ftc.complaint_id)) desc



--STEP 5
--Run this query to produce ACD/ALOC distribution per ANI.
select right(ani, 10) as 'ani'
, account_id
, count(*) as 'calls'
, str((sum(case when duration between 1 and 6 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '1-6 sec %'
, str((sum(case when duration between 7 and 12 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '7-12 sec %'
, str((sum(case when duration between 13 and 18 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '13-18 sec %'
, str((sum(case when duration between 19 and 24 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '19-24 sec %'
, str((sum(case when duration between 25 and 30 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '25-30 sec %'
, str((sum(case when duration between 31 and 36 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '31-36 sec %'
, str((sum(case when duration between 37 and 42 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '37-42 sec %'
, str((sum(case when duration between 43 and 48 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '43-48 sec %'
, str((sum(case when duration between 49 and 54 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '49-54 sec %'
, str((sum(case when duration between 55 and 60 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '55-60 sec %'
, str((sum(case when duration between 61 and 120 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '1-2 min %'
, str((sum(case when duration >= 121 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '2+ min %'
from cdr_in
where sip_code = '200'
group by right(ani, 10), account_id
having count(*) >= 10
order by count(*) desc


--STEP 6
--Run this query to find Invalid ANIs
--NOTE: This query excluded toll-free ANIs are they are not part of the LERG definition.
select right(ani, 10) as 'ani'
, cdr.account_id
, count(*) as 'invalid_attempts'
, 'https://github.com/sip40/scammerscanner/wiki/Invalid-ANI-Ratio' as 'additional_info'
from cdr_in as cdr
where left(right(cdr.ani, 10), 3) not in ('800', '833', '844', '855', '866', '877', '888')
 and left(right(ani, 10), 6) not in (select npanxx from npanxx)
group by right(ani, 10), cdr.account_id
order by count(*) desc, account_id

--select * from cdr_in where account_id = '368' and left(right(ani, 10), 3) not in ('800', '833', '844', '855', '866', '877', '888') and left(right(ani, 10), 6) not in (select npanxx from npanxx)

GO
