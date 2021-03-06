/****** Object:  Table [dbo].[ftc_dnc]    Script Date: 2022-05-25 9:31:11 AM ******/
DROP TABLE [dbo].[ftc_dnc]
GO
/****** Object:  Table [dbo].[ftc_dnc]    Script Date: 2022-05-25 9:31:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ftc_dnc](
	[Company_Phone_Number] [varchar](500) NULL,
	[Created_Date] [smalldatetime] NULL,
	[Violation_Date] [smalldatetime] NULL,
	[Consumer_City] [varchar](500) NULL,
	[Consumer_State] [varchar](500) NULL,
	[Consumer_Area_Code] [varchar](500) NULL,
	[Subject] [varchar](500) NULL,
	[Recorded_Message_Or_Robocall] [varchar](500) NULL,
	[complaint_id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
