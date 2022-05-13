/****** Object:  Table [dbo].[cdr_in]    Script Date: 2022-05-13 8:08:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cdr_in](
	[call_id] [varchar](50) NOT NULL,
	[attempt_date_time] [datetime] NOT NULL,
	[account_id] [varchar](50) NULL,
	[signal_ip_orig] [varchar](50) NULL,
	[media_ip_orig] [varchar](50) NULL,
	[ani] [varchar](50) NULL,
	[dnis] [varchar](50) NULL,
	[sip_code] [int] NOT NULL
) ON [PRIMARY]
GO
