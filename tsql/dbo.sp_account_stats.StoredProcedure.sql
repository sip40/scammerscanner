/****** Object:  StoredProcedure [dbo].[sp_account_stats]    Script Date: 2022-05-13 8:08:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_account_stats]

as

--high level account stats
select account_id
, count(*) as 'attempts'
, (sum(case sip_code when 200 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 as 'asr'
, str((count(distinct(ani)) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'acr'
, case when (count(distinct(ani)) / cast(count(*) as numeric(20, 10))) * 100 >= 90 then 'worth investigating' else '' end as 'acr_result'
, str(((sum(case when right(ani, 10) = right(dnis, 10) then 1 else 0 end)) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'ani_dnis_match_ratio'
, case when ((sum(case when right(ani, 10) = right(dnis, 10) then 1 else 0 end)) / cast(count(*) as numeric(20, 10))) * 100 >= 0.01 then 'worth investigating' else '' end as 'ani_dnis_match_ratio_result'
, str((sum(case sip_code when 403 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '403_ratio'
, case when (sum(case sip_code when 403 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 3 then 'worth investigating' else '' end as '403_ratio_result'
, str((sum(case sip_code when 403 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '403_ratio'
, str((sum(case sip_code when 486 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '486_ratio'
, case when (sum(case sip_code when 486 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 3 then 'worth investigating' else '' end as '486_ratio_result'
, str((sum(case sip_code when 603 then 1 when 607 then 1 when 608 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as '603/607/608_ratio'
, case when (sum(case sip_code when 603 then 1 when 607 then 1 when 608 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 3 then 'worth investigating' else '' end as '603/607/608_ratio_result'
, str((sum(case sip_code when 666 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'youmail_scam_ratio'
, case when (sum(case sip_code when 666 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100 >= 3 then 'worth investigating' else '' end as 'youmail_scam_ratio_result'

from cdr_in
group by account_id
order by count(*) desc


--repeated DNIS per account.
drop table if exists rep_repeated_dnis

select account_id, right(dnis, 10) as 'dnis', count(*) as 'attempts'
into rep_repeated_dnis
from cdr_in
group by account_id, right(dnis, 10)

--select * from rep_repeated_dnis

select account_id
, sum(attempts) as 'attempts'
, sum(case attempts when 1 then 1 else 0 end) as 'dialed_1'
, str((sum(case attempts when 1 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_1%'
, sum(case attempts when 2 then 1 else 0 end) as 'dialed_2'
, str((sum(case attempts when 2 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_2%'
, sum(case attempts when 3 then 1 else 0 end) as 'dialed_3'
, str((sum(case attempts when 3 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_3%'
, sum(case attempts when 4 then 1 else 0 end) as 'dialed_4'
, str((sum(case attempts when 4 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_4%'
, sum(case attempts when 5 then 1 else 0 end) as 'dialed_5'
, str((sum(case attempts when 5 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_5%'
, sum(case attempts when 6 then 1 else 0 end) as 'dialed_6'
, str((sum(case attempts when 6 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_6%'
, sum(case attempts when 7 then 1 else 0 end) as 'dialed_7'
, str((sum(case attempts when 7 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_7%'
, sum(case attempts when 8 then 1 else 0 end) as 'dialed_8'
, str((sum(case attempts when 8 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_8%'
, sum(case attempts when 9 then 1 else 0 end) as 'dialed_9'
, str((sum(case attempts when 9 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_9%'
, sum(case when attempts >= 10 then 1 else 0 end) as 'dialed_10+'
, str((sum(case when attempts >= 10 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'dialed_10+%'
from rep_repeated_dnis
group by account_id
order by sum(attempts) desc



--RVM per account
drop table if exists rep_rvm

select account_id
, cast(attempt_date_time as smalldatetime) as 'attempt_date_time'
, right(dnis, 10) as 'dnis'
, count(*) as 'attempts'
into rep_rvm
from cdr_in
group by account_id, cast(attempt_date_time as smalldatetime), right(dnis, 10)

select account_id
, sum(attempts) as 'attempts'
, sum(case attempts when 2 then 1 else 0 end) as 'rvm_attempts'
, str((sum(case attempts when 2 then 1 else 0 end) / cast(count(*) as numeric(20, 10))) * 100, 5, 2) as 'rvm%'
from rep_rvm
group by account_id
order by sum(attempts) desc


--select * from rep_rvm order by attempts desc

GO
