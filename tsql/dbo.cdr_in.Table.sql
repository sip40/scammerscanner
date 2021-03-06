/****** Object:  Table [dbo].[cdr_in]    Script Date: 2022-06-08 8:26:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cdr_in](
	[call_id] [varchar](50) NOT NULL,
	[attempt_date_time] [datetime] NOT NULL,
	[account_id] [varchar](50) NULL,
	[campaign_id] [varchar](50) NULL,
	[signal_ip_orig] [varchar](50) NULL,
	[media_ip_orig] [varchar](50) NULL,
	[ani] [varchar](50) NULL,
	[dnis] [varchar](50) NULL,
	[sip_code] [int] NOT NULL,
	[duration] [int] NULL,
	[attest_level] [char](1) NULL,
	[ring_time] [int] NULL
) ON [PRIMARY]
GO
